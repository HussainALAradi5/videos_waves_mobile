import 'package:dio/dio.dart';

import '../../../config/api/api_config.dart';
import '../../../config/api/endpoints/video_endpoints.dart';
import '../../../dtos/videos/video/picked_video_dto.dart';
import '../../../dtos/videos/video/video_query_dto.dart';
import '../../../interfaces/services/videos/video/video_service_interface.dart';
import '../../../models/common/pagination/page_result.dart';
import '../../../models/videos/video/video.dart';
import '../../../models/videos/video/video_like_state.dart';
import '../../api/api_client.dart';

class VideoService implements VideoServiceInterface {
  const VideoService(this._client);

  static const String _fileField = 'file';

  final ApiClient _client;

  @override
  Future<PageResult<Video>> list(VideoQueryDto query) =>
      _client.getPage(VideoEndpoints.root, query.toQuery(), Video.fromJson);

  @override
  Future<Video> getById(String videoId) => _client.get(VideoEndpoints.byId(videoId), Video.fromJson);

  @override
  Future<Video> upload({
    required PickedVideoDto file,
    required String title,
    required String description,
    required void Function(double progress) onProgress,
  }) async {
    final multipart = file.bytes != null
        ? MultipartFile.fromBytes(file.bytes!, filename: file.name)
        : await MultipartFile.fromFile(file.path!, filename: file.name);
    final form = FormData.fromMap({_fileField: multipart, 'title': title, 'description': description});
    return _client.post(
      VideoEndpoints.root,
      Video.fromJson,
      body: form,
      options: Options(sendTimeout: ApiConfig.uploadTimeout, receiveTimeout: ApiConfig.uploadTimeout),
      onSendProgress: (sent, total) => onProgress(total > 0 ? sent / total : 0),
    );
  }

  @override
  Future<VideoLikeState> setLiked(String videoId, {required bool isLiked}) => isLiked
      ? _client.put(VideoEndpoints.like(videoId), VideoLikeState.fromJson)
      : _client.delete(VideoEndpoints.like(videoId), VideoLikeState.fromJson);

  @override
  Future<void> recordView(String videoId) => _client.post(VideoEndpoints.views(videoId), ignoreBody);
}
