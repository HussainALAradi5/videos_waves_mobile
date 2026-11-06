import 'package:flutter/material.dart';

import '../../../constants/common/limits_constants.dart';
import '../../../constants/common/messages_constants.dart';
import '../../../constants/common/ui_constants.dart';
import '../../../constants/videos/video/video_messages_constants.dart';
import '../../../controllers/videos/video/video_details_controller.dart';
import '../../../utilities/ui/feedback_utility.dart';
import '../../../validations/videos/video/video_validation.dart';
import '../../../widgets/common/buttons/app_button.dart';
import '../../../widgets/common/forms/app_text_field.dart';

/// Bottom sheet for the owner to change the title and description.
class VideoEditSheet extends StatefulWidget {
  const VideoEditSheet({super.key, required this.details});

  final VideoDetailsController details;

  static Future<void> show(BuildContext context, VideoDetailsController details) => showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        builder: (_) => VideoEditSheet(details: details),
      );

  @override
  State<VideoEditSheet> createState() => _VideoEditSheetState();
}

class _VideoEditSheetState extends State<VideoEditSheet> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  late final TextEditingController _title = TextEditingController(text: widget.details.video?.title);
  late final TextEditingController _description = TextEditingController(text: widget.details.video?.description);

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    final navigator = Navigator.of(context);
    final saved = await runWithFeedback(
      context,
      () => widget.details.update(title: _title.text, description: _description.text),
      successMessage: VideoMessages.videoSaved,
    );
    if (saved) navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(Spacing.md, 0, Spacing.md, MediaQuery.viewInsetsOf(context).bottom + Spacing.md),
      child: Form(
        key: _form,
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(VideoMessages.editVideo, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: Spacing.md),
          AppTextField(controller: _title, label: AppMessages.titleLabel, maxLength: TextLimits.videoTitleMax, validator: validateVideoTitle),
          const SizedBox(height: Spacing.sm),
          AppTextField(controller: _description, label: AppMessages.descriptionLabel, maxLines: 4, maxLength: TextLimits.videoDescriptionMax),
          const SizedBox(height: Spacing.md),
          AppButton(label: AppMessages.save, onPressed: _save),
        ]),
      ),
    );
  }
}
