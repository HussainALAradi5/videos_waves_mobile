import 'dart:async';

import '../../../constants/common/limits_constants.dart';
import '../../../dtos/common/pagination/page_request_dto.dart';
import '../../../dtos/videos/video/video_query_dto.dart';
import '../../../enums/videos/video/feed_scope.dart';
import '../../../interfaces/services/videos/video/video_service_interface.dart';
import '../../../models/common/pagination/page_result.dart';
import '../../../models/videos/video/video.dart';
import '../../common/paged_list_controller.dart';

/// A video list: the For you / Following feed, or one person's videos when [ownerId] is set.
class VideoFeedController extends PagedListController<Video> {
  VideoFeedController(this._videoService, {this.ownerId});

  final VideoServiceInterface _videoService;
  final String? ownerId;
  Timer? _debounce;
  String _search = '';
  FeedScope scope = FeedScope.all;

  @override
  Future<PageResult<Video>> fetchPage(int page) => _videoService.list(
        VideoQueryDto(page: PageRequestDto(page: page, pageSize: PageSizes.feed), search: _search, ownerId: ownerId, scope: scope),
      );

  void setSearch(String value) {
    _debounce?.cancel();
    _debounce = Timer(Timings.searchDebounce, () {
      _search = value.trim();
      loadFirstPage();
    });
  }

  void setScope(FeedScope next) {
    if (next == scope) return;
    scope = next;
    loadFirstPage();
  }

  /// Keeps the feed in sync after a change on the details screen.
  void updateVideo(Video video) => replaceWhere((item) => item.id == video.id, (_) => video);

  void removeVideo(String videoId) => removeWhere((item) => item.id == videoId);

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
