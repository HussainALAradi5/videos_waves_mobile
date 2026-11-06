import 'package:flutter/material.dart';

import '../../../constants/common/messages_constants.dart';
import '../../../constants/common/ui_constants.dart';
import '../../../utilities/errors/api_exception.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({super.key, required this.error, this.onRetry});

  final Object error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Spacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: Spacing.xl * 2, color: theme.colorScheme.error),
            const SizedBox(height: Spacing.md),
            Text(errorMessageOf(error), textAlign: TextAlign.center, style: theme.textTheme.bodyLarge),
            if (onRetry != null) ...[
              const SizedBox(height: Spacing.md),
              OutlinedButton(onPressed: onRetry, child: const Text(AppMessages.retry)),
            ],
          ],
        ),
      ),
    );
  }
}
