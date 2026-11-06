import '../../../constants/videos/video/video_limits_constants.dart';
import '../../../dtos/media/media/picked_file_dto.dart';
import '../../../enums/media/media/media_kind.dart';
import '../../../interfaces/services/videos/video/video_service_interface.dart';
import '../../../models/media/upload/upload_item.dart';
import '../../../services/media/media/media_upload_service.dart';
import '../../media/upload/upload_queue_controller.dart';

/// Several videos at once: each uploads straight away, then Publish creates them one by one.
class VideoBatchUploadController extends UploadQueueController {
  VideoBatchUploadController(MediaUploadService uploads, this._videoService)
      : super(uploads, MediaKind.video, maxFiles: VideoLimits.maxBatch);

  final VideoServiceInterface _videoService;
  final Map<int, String> _titles = {};
  final Map<int, String> _descriptions = {};
  bool isPublishing = false;

  @override
  int add(List<PickedFileDto> files) {
    final skipped = super.add(files);
    for (final item in items) {
      _titles.putIfAbsent(item.id, () => _titleFrom(item.file.name));
    }
    return skipped;
  }

  String titleOf(UploadItem item) => _titles[item.id] ?? '';
  String descriptionOf(UploadItem item) => _descriptions[item.id] ?? '';

  void setTitle(UploadItem item, String value) => _titles[item.id] = value;
  void setDescription(UploadItem item, String value) => _descriptions[item.id] = value;

  bool get canPublish => isReady && !isPublishing && items.every((item) => titleOf(item).trim().isNotEmpty);

  /// Creates every uploaded video in order; published ones leave the queue so a retry skips them.
  Future<int> publish() async {
    isPublishing = true;
    notifyListeners();
    var published = 0;
    try {
      for (final item in items) {
        await _videoService.create(mediaId: item.media!.id, title: titleOf(item).trim(), description: descriptionOf(item).trim());
        remove(item);
        published++;
      }
    } finally {
      isPublishing = false;
      notifyListeners();
    }
    return published;
  }

  static String _titleFrom(String fileName) {
    final dot = fileName.lastIndexOf('.');
    return (dot > 0 ? fileName.substring(0, dot) : fileName).replaceAll(RegExp(r'[_-]+'), ' ').trim();
  }
}
