import '../../../config/api/endpoints/video_endpoints.dart';
import '../../../dtos/common/pagination/page_request_dto.dart';
import '../../../interfaces/services/videos/comment/comment_service_interface.dart';
import '../../../models/common/pagination/page_result.dart';
import '../../../models/videos/comment/comment.dart';
import '../../api/api_client.dart';

class CommentService implements CommentServiceInterface {
  const CommentService(this._client);

  final ApiClient _client;

  @override
  Future<PageResult<Comment>> list(String videoId, PageRequestDto page) =>
      _client.getPage(VideoEndpoints.comments(videoId), page.toQuery(), Comment.fromJson);

  @override
  Future<Comment> create(String videoId, String content) =>
      _client.post(VideoEndpoints.comments(videoId), Comment.fromJson, body: {'content': content});

  @override
  Future<void> remove(String videoId, String commentId) =>
      _client.delete(VideoEndpoints.comment(videoId, commentId), ignoreBody);
}
