import 'package:flutter/material.dart';

import '../../../constants/common/radii_constants.dart';
import '../../../constants/common/spacing_constants.dart';
import '../../../enums/media/upload/upload_status.dart';
import '../../../models/media/upload/upload_item.dart';
import '../../../utilities/format/media_format_utility.dart';
import '../feedback/app_progress_bar.dart';

/// One queued file: thumbnail or icon, name, size, progress, and remove or retry.
class FilePreviewTile extends StatelessWidget {
  const FilePreviewTile({super.key, required this.item, required this.onRemove, required this.onRetry, this.child});

  final UploadItem item;
  final VoidCallback onRemove;
  final VoidCallback onRetry;

  /// Extra fields under the file row (the video title and description).
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bytes = item.file.bytes;
    final preview = item.isImage && bytes != null
        ? Image.memory(bytes, width: 48, height: 48, fit: BoxFit.cover)
        : Icon(item.isVideo ? Icons.movie_outlined : Icons.insert_drive_file_outlined, color: scheme.primary);
    return Card(
      margin: const EdgeInsets.only(bottom: Spacing.sm),
      child: Padding(
        padding: const EdgeInsets.all(Spacing.sm),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(children: [
            ClipRRect(borderRadius: BorderRadius.circular(Radii.md), child: SizedBox.square(dimension: 48, child: Center(child: preview))),
            const SizedBox(width: Spacing.sm),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(item.file.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(item.error ?? formatFileSize(item.file.sizeBytes),
                    style: TextStyle(fontSize: 12, color: item.error == null ? scheme.onSurfaceVariant : scheme.error)),
              ]),
            ),
            if (item.status == UploadStatus.failed) IconButton(icon: const Icon(Icons.refresh), onPressed: onRetry),
            if (item.isDone) Icon(Icons.check_circle, color: scheme.primary),
            IconButton(icon: const Icon(Icons.close), onPressed: onRemove),
          ]),
          if (item.status == UploadStatus.uploading) Padding(padding: const EdgeInsets.only(top: Spacing.xs), child: AppProgressBar(value: item.progress)),
          ?child,
        ]),
      ),
    );
  }
}
