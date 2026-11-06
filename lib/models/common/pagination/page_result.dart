import 'page_meta.dart';

/// One page of a server list: its items and the page metadata.
class PageResult<T> {
  const PageResult({required this.items, required this.meta});

  final List<T> items;
  final PageMeta meta;
}
