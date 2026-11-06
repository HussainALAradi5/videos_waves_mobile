import 'package:flutter/material.dart';

import '../../../constants/common/limits_constants.dart';
import '../../../constants/common/messages_constants.dart';
import '../../../constants/common/ui_constants.dart';
import '../../../controllers/common/paged_list_controller.dart';
import '../feedback/error_view.dart';
import '../feedback/loading_view.dart';

/// Any server-paged list: pull to refresh, loads the next page near the end,
/// and shows loading, error, and empty states.
class PagedListView<T> extends StatelessWidget {
  const PagedListView({super.key, required this.controller, required this.itemBuilder, required this.empty});

  final PagedListController<T> controller;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final Widget empty;

  bool _onScroll(ScrollNotification notification) {
    if (notification.metrics.extentAfter < kLoadMoreThreshold) controller.loadNextPage();
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final items = controller.items;
        if (controller.isLoading && items.isEmpty) return const LoadingView();
        if (controller.error != null && items.isEmpty) {
          return ErrorView(error: controller.error!, onRetry: controller.loadFirstPage);
        }
        return RefreshIndicator(
          onRefresh: controller.loadFirstPage,
          child: NotificationListener<ScrollNotification>(
            onNotification: _onScroll,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(Spacing.md),
              itemCount: items.isEmpty ? 1 : items.length + 1,
              itemBuilder: (context, index) {
                if (items.isEmpty) return empty;
                if (index < items.length) return itemBuilder(context, items[index]);
                return _Footer(isLoadingMore: controller.isLoadingMore, hasMore: controller.hasMore);
              },
            ),
          ),
        );
      },
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({required this.isLoadingMore, required this.hasMore});

  final bool isLoadingMore;
  final bool hasMore;

  @override
  Widget build(BuildContext context) {
    if (isLoadingMore) return const LoadingView();
    if (hasMore) return const SizedBox(height: Spacing.xl);
    return Padding(
      padding: const EdgeInsets.all(Spacing.lg),
      child: Text(AppMessages.endOfList, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodySmall),
    );
  }
}
