import '../../../constants/common/limits_constants.dart';
import '../../../dtos/common/pagination/page_request_dto.dart';
import '../../../interfaces/services/videos/comment/comment_service_interface.dart';
import '../../../models/common/pagination/page_result.dart';
import '../../../models/videos/comment/comment.dart';
import '../../common/paged_list_controller.dart';

/// Comments on a video, or the replies under one comment when [parentId] is set.
class CommentListController extends PagedListController<Comment> {
  CommentListController(this._commentService, this.videoId, {this.parentId});

  final CommentServiceInterface _commentService;
  final String videoId;
  final String? parentId;
  bool isPosting = false;

  @override
  Future<PageResult<Comment>> fetchPage(int page) {
    final request = PageRequestDto(page: page, pageSize: parentId == null ? PageSizes.comments : PageSizes.replies);
    return parentId == null ? _commentService.list(videoId, request) : _commentService.replies(videoId, parentId!, request);
  }

  Future<void> add(String content) async {
    isPosting = true;
    notifyListeners();
    try {
      insertFirst(await _commentService.create(videoId, content.trim(), parentId: parentId));
    } finally {
      isPosting = false;
      notifyListeners();
    }
  }

  Future<void> edit(Comment comment, String content) async {
    final updated = await _commentService.update(videoId, comment.id, content.trim());
    replaceWhere((item) => item.id == comment.id, (_) => updated);
  }

  /// Hides the comment at once; returns its position so Undo can put it back there.
  Future<int> remove(Comment comment) async {
    final index = indexWhere((item) => item.id == comment.id);
    removeWhere((item) => item.id == comment.id);
    try {
      await _commentService.remove(videoId, comment.id);
    } catch (_) {
      insertAt(index, comment);
      rethrow;
    }
    return index;
  }

  Future<void> restore(Comment comment, int index) async => insertAt(index, await _commentService.restore(videoId, comment.id));

  Future<void> approve(Comment comment) async {
    final approved = await _commentService.approve(videoId, comment.id);
    replaceWhere((item) => item.id == comment.id, (_) => approved);
  }

  void adjustReplies(String commentId, int delta) =>
      replaceWhere((item) => item.id == commentId, (item) => item.copyWith(repliesCount: item.repliesCount + delta));
}
