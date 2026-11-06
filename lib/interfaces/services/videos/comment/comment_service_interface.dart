import '../../../../dtos/common/pagination/page_request_dto.dart';
import '../../../../models/common/pagination/page_result.dart';
import '../../../../models/videos/comment/comment.dart';

abstract interface class CommentServiceInterface {
  Future<PageResult<Comment>> list(String videoId, PageRequestDto page);
  Future<Comment> create(String videoId, String content);
  Future<void> remove(String videoId, String commentId);
}
