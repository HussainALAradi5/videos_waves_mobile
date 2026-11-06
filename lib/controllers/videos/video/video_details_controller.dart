import 'package:flutter/foundation.dart';

import '../../../interfaces/services/videos/video/video_service_interface.dart';
import '../../../models/videos/video/video.dart';

/// One video: loading, an optimistic like toggle, one counted view per visit, and owner edits.
class VideoDetailsController extends ChangeNotifier {
  VideoDetailsController(this._videoService, this.videoId, {this.onVideoChanged, this.onVideoDeleted});

  final VideoServiceInterface _videoService;
  final String videoId;
  final void Function(Video video)? onVideoChanged;
  final void Function(String videoId)? onVideoDeleted;

  Video? video;
  Object? error;
  bool isLoading = true;
  bool isLiking = false;
  bool _hasRecordedView = false;

  Future<void> load() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      video = await _videoService.getById(videoId);
    } catch (caught) {
      error = caught;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Updates the UI immediately and rolls back if the API rejects the change.
  Future<void> toggleLike() async {
    final current = video;
    if (current == null || isLiking) return;
    final shouldLike = !current.isLiked;
    _setVideo(current.copyWith(isLiked: shouldLike, likesCount: current.likesCount + (shouldLike ? 1 : -1)));
    isLiking = true;
    try {
      final state = await _videoService.setLiked(videoId, isLiked: shouldLike);
      _setVideo(video!.copyWith(isLiked: state.isLiked, likesCount: state.likesCount));
    } catch (_) {
      _setVideo(current);
      rethrow;
    } finally {
      isLiking = false;
      notifyListeners();
    }
  }

  void recordViewOnce() {
    if (_hasRecordedView || video == null) return;
    _hasRecordedView = true;
    _videoService.recordView(videoId).then((_) {
      _setVideo(video!.copyWith(viewsCount: video!.viewsCount + 1));
    }).catchError((Object _) {
      _hasRecordedView = false;
    });
  }

  Future<void> update({required String title, required String description}) async {
    final updated = await _videoService.update(videoId, title: title.trim(), description: description.trim());
    _setVideo(video!.copyWith(title: updated.title, description: updated.description));
  }

  Future<void> remove() async {
    await _videoService.remove(videoId);
    onVideoDeleted?.call(videoId);
  }

  void adjustCommentsCount(int delta) {
    final current = video;
    if (current != null) _setVideo(current.copyWith(commentsCount: current.commentsCount + delta));
  }

  void _setVideo(Video next) {
    video = next;
    onVideoChanged?.call(next);
    notifyListeners();
  }
}
