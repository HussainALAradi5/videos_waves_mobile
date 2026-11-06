import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../constants/common/limits_constants.dart';
import '../../../constants/common/messages_constants.dart';
import '../../../constants/common/routes_constants.dart';
import '../../../constants/common/ui_constants.dart';
import '../../../constants/videos/video/video_messages_constants.dart';
import '../../../controllers/videos/video/video_batch_upload_controller.dart';
import '../../../controllers/videos/video/video_feed_controller.dart';
import '../../../globals/app_dependencies.dart';
import '../../../models/media/upload/upload_item.dart';
import '../../../utilities/ui/feedback_utility.dart';
import '../../../widgets/common/buttons/app_button.dart';
import '../../../widgets/common/layout/constrained_content.dart';
import '../../../widgets/common/uploads/multi_file_picker.dart';

/// Upload several videos at once: each goes straight to the CDN, then Publish creates them.
class VideoUploadScreen extends StatefulWidget {
  const VideoUploadScreen({super.key});

  @override
  State<VideoUploadScreen> createState() => _VideoUploadScreenState();
}

class _VideoUploadScreenState extends State<VideoUploadScreen> {
  late final VideoBatchUploadController _batch = () {
    final dependencies = context.read<AppDependencies>();
    return VideoBatchUploadController(dependencies.mediaUploadService, dependencies.videoService);
  }();

  @override
  void dispose() {
    _batch.dispose();
    super.dispose();
  }

  Future<void> _publish() async {
    final feed = context.read<VideoFeedController>();
    final router = GoRouter.of(context);
    var count = 0;
    final isDone = await runWithFeedback(context, () async => count = await _batch.publish());
    if (!mounted || count == 0) return;
    showMessage(context, VideoMessages.published(count));
    feed.loadFirstPage();
    if (isDone) router.go(AppRoutes.feed);
  }

  Widget _fields(UploadItem item) => Padding(
        padding: const EdgeInsets.only(top: Spacing.sm),
        child: Column(children: [
          TextFormField(
            initialValue: _batch.titleOf(item),
            maxLength: TextLimits.videoTitleMax,
            onChanged: (value) => setState(() => _batch.setTitle(item, value)),
            decoration: const InputDecoration(labelText: AppMessages.titleLabel, isDense: true),
          ),
          TextFormField(
            initialValue: _batch.descriptionOf(item),
            maxLength: TextLimits.videoDescriptionMax,
            maxLines: 2,
            minLines: 1,
            onChanged: (value) => _batch.setDescription(item, value),
            decoration: const InputDecoration(labelText: AppMessages.descriptionLabel, isDense: true),
          ),
        ]),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(VideoMessages.uploadTitle)),
      body: ConstrainedContent(
        child: ListView(padding: const EdgeInsets.all(Spacing.md), children: [
          Text(VideoMessages.uploadHint, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: Spacing.md),
          MultiFilePicker(
            queue: _batch,
            type: FileType.video,
            label: VideoMessages.chooseVideos,
            skippedMessage: VideoMessages.skippedFiles,
            tileChild: _fields,
          ),
          const SizedBox(height: Spacing.md),
          ListenableBuilder(
            listenable: _batch,
            builder: (context, _) => AppButton(
              label: VideoMessages.publish,
              icon: Icons.publish,
              isLoading: _batch.isPublishing,
              onPressed: _batch.canPublish ? _publish : null,
            ),
          ),
        ]),
      ),
    );
  }
}
