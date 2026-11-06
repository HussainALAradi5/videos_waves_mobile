import '../../../constants/common/limits_constants.dart';
import '../../../dtos/common/pagination/page_request_dto.dart';
import '../../../interfaces/services/videos/comment/comment_service_interface.dart';
import '../../../models/common/pagination/page_result.dart';
import '../../../models/videos/comment/comment.dart';
import '../../common/paged_list_controller.dart';

class CommentListController extends PagedListController<Comment> {
  CommentListController(this._commentService, this.videoId);

  final CommentServiceInterface _commentService;
  final String videoId;
  bool isPosting = false;

  @override
  Future<PageResult<Comment>> fetchPage(int page) =>
      _commentService.list(videoId, PageRequestDto(page: page, pageSize: PageSizes.comments));

  Future<void> add(String content) async {
    isPosting = true;
    notifyListeners();
    try {
      insertFirst(await _commentService.create(videoId, content.trim()));
    } finally {
      isPosting = false;
      notifyListeners();
    }
  }

  Future<void> remove(Comment comment) async {
    await _commentService.remove(videoId, comment.id);
    removeWhere((item) => item.id == comment.id);
  }
}
