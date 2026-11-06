import '../../common/pagination/page_request_dto.dart';

class VideoQueryDto {
  const VideoQueryDto({required this.page, this.search, this.ownerId});

  final PageRequestDto page;
  final String? search;
  final String? ownerId;

  Map<String, Object> toQuery() => {
        ...page.toQuery(),
        if (search != null && search!.isNotEmpty) 'search': search!,
        'ownerId': ?ownerId,
      };
}
