import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../../constants/common/radii_constants.dart';
import '../../../constants/common/spacing_constants.dart';
import '../../../controllers/media/upload/upload_queue_controller.dart';
import '../../../models/media/upload/upload_item.dart';
import '../../../utilities/media/file_pick_utility.dart';
import '../../../utilities/ui/feedback_utility.dart';
import 'file_preview_tile.dart';

/// A dashed drop area that opens the picker, then one tile per file in the queue.
class MultiFilePicker extends StatelessWidget {
  const MultiFilePicker({super.key, required this.queue, required this.type, required this.label, required this.skippedMessage, this.tileChild});

  final UploadQueueController queue;
  final FileType type;
  final String label;
  final String skippedMessage;
  final Widget Function(UploadItem item)? tileChild;

  Future<void> _pick(BuildContext context) async {
    final files = await pickFiles(type);
    if (files.isEmpty) return;
    if (queue.add(files) > 0 && context.mounted) showMessage(context, skippedMessage);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListenableBuilder(
      listenable: queue,
      builder: (context, _) => Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        if (!queue.isFull)
          InkWell(
            borderRadius: BorderRadius.circular(Radii.lg),
            onTap: () => _pick(context),
            child: Container(
              padding: const EdgeInsets.all(Spacing.lg),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Radii.lg),
                border: Border.all(color: scheme.primary.withValues(alpha: 0.5), width: 1.5),
                color: scheme.primary.withValues(alpha: 0.05),
              ),
              child: Column(children: [
                Icon(Icons.cloud_upload_outlined, size: 36, color: scheme.primary),
                const SizedBox(height: Spacing.sm),
                Text(label, style: TextStyle(color: scheme.primary, fontWeight: FontWeight.w600)),
              ]),
            ),
          ),
        const SizedBox(height: Spacing.md),
        for (final item in queue.items)
          FilePreviewTile(
            key: ValueKey(item.id),
            item: item,
            onRemove: () => queue.remove(item),
            onRetry: () => queue.retry(item),
            child: tileChild?.call(item),
          ),
      ]),
    );
  }
}
