import 'dart:async';

import '../../../constants/common/limits_constants.dart';
import '../../../dtos/common/pagination/page_request_dto.dart';
import '../../../dtos/videos/video/video_query_dto.dart';
import '../../../interfaces/services/videos/video/video_service_interface.dart';
import '../../../models/common/pagination/page_result.dart';
import '../../../models/videos/video/video.dart';
import '../../common/paged_list_controller.dart';

/// The home feed: server-side search and paging, with a debounced search box.
class VideoFeedController extends PagedListController<Video> {
  VideoFeedController(this._videoService);

  final VideoServiceInterface _videoService;
  Timer? _debounce;
  String _search = '';

  @override
  Future<PageResult<Video>> fetchPage(int page) => _videoService.list(
        VideoQueryDto(page: PageRequestDto(page: page, pageSize: PageSizes.feed), search: _search),
      );

  void setSearch(String value) {
    _debounce?.cancel();
    _debounce = Timer(Timings.searchDebounce, () {
      _search = value.trim();
      loadFirstPage();
    });
  }

  /// Keeps the feed in sync after a like or comment on the details screen.
  void updateVideo(Video video) => replaceWhere((item) => item.id == video.id, (_) => video);

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
