import 'package:flutter/foundation.dart';

import '../../models/common/pagination/page_meta.dart';
import '../../models/common/pagination/page_result.dart';

/// Shared infinite-list state for any server-paged resource.
/// A generation counter drops results from requests that were superseded (for example a new search).
abstract class PagedListController<T> extends ChangeNotifier {
  static const int firstPage = 1;

  final List<T> _items = [];
  PageMeta? _meta;
  int _generation = 0;

  bool isLoading = false;
  bool isLoadingMore = false;
  Object? error;

  List<T> get items => List.unmodifiable(_items);
  bool get hasMore => _meta?.hasNextPage ?? false;
  bool get isEmpty => !isLoading && error == null && _items.isEmpty;
  int get totalItems => _meta?.totalItems ?? 0;

  @protected
  Future<PageResult<T>> fetchPage(int page);

  Future<void> loadFirstPage() async {
    final generation = ++_generation;
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      final result = await fetchPage(firstPage);
      if (generation != _generation) return;
      _items
        ..clear()
        ..addAll(result.items);
      _meta = result.meta;
    } catch (caught) {
      if (generation == _generation) error = caught;
    } finally {
      if (generation == _generation) {
        isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<void> loadNextPage() async {
    final meta = _meta;
    if (isLoading || isLoadingMore || meta == null || !meta.hasNextPage) return;
    final generation = _generation;
    isLoadingMore = true;
    notifyListeners();
    try {
      final result = await fetchPage(meta.page + 1);
      if (generation != _generation) return;
      _items.addAll(result.items);
      _meta = result.meta;
    } catch (caught) {
      if (generation == _generation) error = caught;
    } finally {
      if (generation == _generation) {
        isLoadingMore = false;
        notifyListeners();
      }
    }
  }

  @protected
  void replaceWhere(bool Function(T item) test, T Function(T item) update) {
    final index = _items.indexWhere(test);
    if (index < 0) return;
    _items[index] = update(_items[index]);
    notifyListeners();
  }

  @protected
  void insertFirst(T item) {
    _items.insert(0, item);
    _meta = _meta == null ? null : _withTotal(_meta!, 1);
    notifyListeners();
  }

  @protected
  void removeWhere(bool Function(T item) test) {
    final before = _items.length;
    _items.removeWhere(test);
    final removed = before - _items.length;
    if (removed > 0 && _meta != null) _meta = _withTotal(_meta!, -removed);
    notifyListeners();
  }

  PageMeta _withTotal(PageMeta meta, int delta) => PageMeta(
        page: meta.page,
        pageSize: meta.pageSize,
        totalItems: meta.totalItems + delta,
        totalPages: meta.totalPages,
      );
}
