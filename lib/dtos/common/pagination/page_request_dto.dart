import '../../../enums/common/sort_direction.dart';

/// Shared page request; domain queries add their own filters on top of [toQuery].
class PageRequestDto {
  const PageRequestDto({required this.page, required this.pageSize, this.sortBy, this.sortDirection});

  final int page;
  final int pageSize;
  final String? sortBy;
  final SortDirection? sortDirection;

  Map<String, Object> toQuery() => {
        'page': page,
        'pageSize': pageSize,
        'sortBy': ?sortBy,
        'sortDirection': ?sortDirection?.wireValue,
      };
}
