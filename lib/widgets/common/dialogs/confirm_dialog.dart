import 'package:flutter/material.dart';

import '../../../constants/common/messages_constants.dart';

/// Confirmation for destructive actions; resolves to true only when confirmed.
class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({super.key, required this.title, required this.message, required this.confirmLabel});

  final String title;
  final String message;
  final String confirmLabel;

  static Future<bool> show(BuildContext context, {required String title, required String message, required String confirmLabel}) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => ConfirmDialog(title: title, message: message, confirmLabel: confirmLabel),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text(AppMessages.cancel)),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: colors.error, foregroundColor: colors.onError),
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(confirmLabel),
        ),
      ],
    );
  }
}
