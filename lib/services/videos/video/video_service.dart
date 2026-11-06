import '../../../config/api/endpoints/video_endpoints.dart';
import '../../../dtos/videos/video/video_query_dto.dart';
import '../../../interfaces/services/videos/video/video_service_interface.dart';
import '../../../models/common/pagination/page_result.dart';
import '../../../models/videos/video/video.dart';
import '../../../models/videos/video/video_like_state.dart';
import '../../api/api_client.dart';

class VideoService implements VideoServiceInterface {
  const VideoService(this._client);

  final ApiClient _client;

  @override
  Future<PageResult<Video>> list(VideoQueryDto query) => _client.getPage(VideoEndpoints.root, query.toQuery(), Video.fromJson);

  @override
  Future<Video> getById(String videoId) => _client.get(VideoEndpoints.byId(videoId), Video.fromJson);

  /// Publishes media uploaded with MediaUploadService.
  @override
  Future<Video> create({required String mediaId, required String title, required String description}) =>
      _client.post(VideoEndpoints.root, Video.fromJson, body: {'mediaId': mediaId, 'title': title, 'description': description});

  @override
  Future<Video> update(String videoId, {required String title, required String description}) =>
      _client.patch(VideoEndpoints.byId(videoId), Video.fromJson, body: {'title': title, 'description': description});

  @override
  Future<void> remove(String videoId) => _client.delete(VideoEndpoints.byId(videoId), ignoreBody);

  @override
  Future<VideoLikeState> setLiked(String videoId, {required bool isLiked}) => isLiked
      ? _client.put(VideoEndpoints.like(videoId), VideoLikeState.fromJson)
      : _client.delete(VideoEndpoints.like(videoId), VideoLikeState.fromJson);

  @override
  Future<void> recordView(String videoId) => _client.post(VideoEndpoints.views(videoId), ignoreBody);
}
