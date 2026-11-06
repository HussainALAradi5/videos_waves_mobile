import 'package:videos_waves_mobile/dtos/common/pagination/page_request_dto.dart';
import 'package:videos_waves_mobile/interfaces/services/videos/comment/comment_service_interface.dart';
import 'package:videos_waves_mobile/models/common/pagination/page_meta.dart';
import 'package:videos_waves_mobile/models/common/pagination/page_result.dart';
import 'package:videos_waves_mobile/models/users/user/public_user.dart';
import 'package:videos_waves_mobile/models/videos/comment/comment.dart';

Comment buildComment(String id, {String content = 'hi'}) => Comment(
      id: id,
      code: 'CMT-$id',
      videoId: 'v1',
      content: content,
      author: const PublicUser(id: 'ana', userName: 'ana'),
      createdAt: DateTime(2026),
    );

/// In-memory comments for one video.
class FakeCommentService implements CommentServiceInterface {
  FakeCommentService(int count) : comments = [for (var index = 0; index < count; index++) buildComment('c$index')];

  final List<Comment> comments;
  bool shouldFailRemove = false;

  PageResult<Comment> _page(List<Comment> items) =>
      PageResult(items: items, meta: PageMeta(page: 1, pageSize: 10, totalItems: items.length, totalPages: 1));

  @override
  Future<PageResult<Comment>> list(String videoId, PageRequestDto page) async => _page(comments);

  @override
  Future<PageResult<Comment>> replies(String videoId, String commentId, PageRequestDto page) async => _page(const []);

  @override
  Future<Comment> create(String videoId, String content, {String? parentId}) async => buildComment('new', content: content);

  @override
  Future<Comment> update(String videoId, String commentId, String content) async =>
      buildComment(commentId, content: content).copyWith(isEdited: true);

  @override
  Future<void> remove(String videoId, String commentId) async {
    if (shouldFailRemove) throw Exception('remove failed');
  }

  @override
  Future<Comment> restore(String videoId, String commentId) async => buildComment(commentId);

  @override
  Future<Comment> approve(String videoId, String commentId) async => buildComment(commentId).copyWith(isPendingApproval: false);
}
