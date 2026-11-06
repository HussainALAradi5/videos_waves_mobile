import 'package:flutter/material.dart';

import '../../../constants/common/radii_constants.dart';
import '../../../enums/media/upload/upload_status.dart';
import '../../../controllers/media/upload/upload_queue_controller.dart';

/// Horizontal strip of queued attachments, each with a progress ring and remove or retry.
class AttachmentStrip extends StatelessWidget {
  const AttachmentStrip({super.key, required this.queue});

  final UploadQueueController queue;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 76,
      child: ListView(scrollDirection: Axis.horizontal, children: [
        for (final item in queue.items)
          Padding(
            key: ValueKey(item.id),
            padding: const EdgeInsets.all(4),
            child: Stack(children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(Radii.md),
                child: Container(
                  width: 64,
                  height: 64,
                  color: scheme.surfaceContainerHighest,
                  child: item.isImage && item.file.bytes != null
                      ? Image.memory(item.file.bytes!, fit: BoxFit.cover)
                      : Icon(item.isVideo ? Icons.movie_outlined : Icons.insert_drive_file_outlined),
                ),
              ),
              if (item.status == UploadStatus.uploading)
                Positioned.fill(child: Center(child: CircularProgressIndicator(value: item.progress, strokeWidth: 3))),
              if (item.status == UploadStatus.failed)
                Positioned.fill(child: IconButton(icon: Icon(Icons.refresh, color: scheme.error), onPressed: () => queue.retry(item))),
              Positioned(
                right: 0,
                top: 0,
                child: InkWell(
                  onTap: () => queue.remove(item),
                  child: const CircleAvatar(radius: 10, backgroundColor: Colors.black54, child: Icon(Icons.close, size: 12, color: Colors.white)),
                ),
              ),
            ]),
          ),
      ]),
    );
  }
}
