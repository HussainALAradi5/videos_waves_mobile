import '../json_map.dart';

class PageMeta {
  const PageMeta({required this.page, required this.pageSize, required this.totalItems, required this.totalPages});

  factory PageMeta.fromJson(JsonMap json) => PageMeta(
        page: json['page'] as int,
        pageSize: json['pageSize'] as int,
        totalItems: json['totalItems'] as int,
        totalPages: json['totalPages'] as int,
      );

  final int page;
  final int pageSize;
  final int totalItems;
  final int totalPages;

  bool get hasNextPage => page < totalPages;
}
