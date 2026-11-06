/// A "load older" page: items newest first, and the cursor for the next (older) page.
class CursorPage<T> {
  const CursorPage({required this.items, required this.nextCursor});

  final List<T> items;
  final String? nextCursor;

  bool get hasMore => nextCursor != null;
}
