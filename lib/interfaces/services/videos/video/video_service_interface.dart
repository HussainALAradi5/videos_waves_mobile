import '../../../../dtos/videos/video/video_query_dto.dart';
import '../../../../models/common/pagination/page_result.dart';
import '../../../../models/videos/video/video.dart';
import '../../../../models/videos/video/video_like_state.dart';

abstract interface class VideoServiceInterface {
  Future<PageResult<Video>> list(VideoQueryDto query);
  Future<Video> getById(String videoId);
  Future<Video> create({required String mediaId, required String title, required String description});
  Future<Video> update(String videoId, {required String title, required String description});
  Future<void> remove(String videoId);
  Future<VideoLikeState> setLiked(String videoId, {required bool isLiked});
  Future<void> recordView(String videoId);
}
