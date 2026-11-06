import '../../../../dtos/videos/video/picked_video_dto.dart';
import '../../../../dtos/videos/video/video_query_dto.dart';
import '../../../../models/common/pagination/page_result.dart';
import '../../../../models/videos/video/video.dart';
import '../../../../models/videos/video/video_like_state.dart';

abstract interface class VideoServiceInterface {
  Future<PageResult<Video>> list(VideoQueryDto query);
  Future<Video> getById(String videoId);
  Future<Video> upload({
    required PickedVideoDto file,
    required String title,
    required String description,
    required void Function(double progress) onProgress,
  });
  Future<VideoLikeState> setLiked(String videoId, {required bool isLiked});
  Future<void> recordView(String videoId);
}
