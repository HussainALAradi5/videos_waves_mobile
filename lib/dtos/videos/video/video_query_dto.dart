import '../../../enums/videos/video/feed_scope.dart';
import '../../common/pagination/page_request_dto.dart';

class VideoQueryDto {
  const VideoQueryDto({required this.page, this.search, this.ownerId, this.scope = FeedScope.all});

  final PageRequestDto page;
  final String? search;
  final String? ownerId;
  final FeedScope scope;

  Map<String, Object> toQuery() => {
        ...page.toQuery(),
        if (search != null && search!.isNotEmpty) 'search': search!,
        'ownerId': ?ownerId,
        'scope': scope.wire,
      };
}
