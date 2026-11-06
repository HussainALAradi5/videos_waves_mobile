import 'package:videos_waves_mobile/dtos/videos/video/video_query_dto.dart';
import 'package:videos_waves_mobile/interfaces/services/videos/video/video_service_interface.dart';
import 'package:videos_waves_mobile/models/common/pagination/page_meta.dart';
import 'package:videos_waves_mobile/models/common/pagination/page_result.dart';
import 'package:videos_waves_mobile/models/users/user/public_user.dart';
import 'package:videos_waves_mobile/models/videos/video/video.dart';
import 'package:videos_waves_mobile/models/videos/video/video_like_state.dart';

Video buildVideo(String id, {bool isLiked = false, int likesCount = 0}) => Video(
      id: id,
      code: 'VID-$id',
      title: 'Video $id',
      description: '',
      videoUrl: 'http://localhost:5000/media/videos/$id.mp4',
      owner: const PublicUser(id: 'owner', userName: 'owner'),
      likesCount: likesCount,
      commentsCount: 0,
      viewsCount: 0,
      isLiked: isLiked,
      createdAt: DateTime(2026),
    );

/// In-memory video service: [totalItems] videos split into pages of [pageSize].
class FakeVideoService implements VideoServiceInterface {
  FakeVideoService({this.totalItems = 5, this.pageSize = 2});

  final int totalItems;
  final int pageSize;
  final List<int> requestedPages = [];
  bool shouldFailLike = false;

  @override
  Future<PageResult<Video>> list(VideoQueryDto query) async {
    final page = query.page.page;
    requestedPages.add(page);
    final start = (page - 1) * pageSize;
    final end = (start + pageSize).clamp(0, totalItems);
    return PageResult(
      items: [for (var index = start; index < end; index++) buildVideo('$index')],
      meta: PageMeta(page: page, pageSize: pageSize, totalItems: totalItems, totalPages: (totalItems / pageSize).ceil()),
    );
  }

  @override
  Future<Video> getById(String videoId) async => buildVideo(videoId);

  @override
  Future<VideoLikeState> setLiked(String videoId, {required bool isLiked}) async {
    if (shouldFailLike) throw Exception('like failed');
    return VideoLikeState(videoId: videoId, isLiked: isLiked, likesCount: isLiked ? 1 : 0);
  }

  @override
  Future<void> recordView(String videoId) async {}

  final List<String> createdTitles = [];

  @override
  Future<Video> create({required String mediaId, required String title, required String description}) async {
    createdTitles.add(title);
    return buildVideo(mediaId);
  }

  @override
  Future<Video> update(String videoId, {required String title, required String description}) async => buildVideo(videoId);

  @override
  Future<void> remove(String videoId) async {}
}
