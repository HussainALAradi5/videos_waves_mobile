import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../constants/common/limits_constants.dart';
import '../../../constants/common/messages_constants.dart';
import '../../../constants/common/routes_constants.dart';
import '../../../constants/common/ui_constants.dart';
import '../../../controllers/videos/video/video_feed_controller.dart';
import '../../../controllers/videos/video/video_upload_controller.dart';
import '../../../utilities/ui/feedback_utility.dart';
import '../../../validations/videos/video/video_validation.dart';
import '../../../widgets/common/forms/app_text_field.dart';
import '../../../widgets/common/forms/submit_button.dart';
import '../../../widgets/common/layout/constrained_content.dart';

class VideoUploadForm extends StatefulWidget {
  const VideoUploadForm({super.key});

  @override
  State<VideoUploadForm> createState() => _VideoUploadFormState();
}

class _VideoUploadFormState extends State<VideoUploadForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _title = TextEditingController();
  final TextEditingController _description = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final upload = context.read<VideoUploadController>();
    if (!_formKey.currentState!.validate()) return;
    if (upload.file == null) return showMessage(context, AppMessages.fileRequired);
    final feed = context.read<VideoFeedController>();
    final router = GoRouter.of(context);
    await runWithFeedback(context, successMessage: AppMessages.uploadSuccess, () async {
      final video = await upload.upload(title: _title.text, description: _description.text);
      feed.loadFirstPage();
      router.push(AppRoutes.video(video.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    final upload = context.watch<VideoUploadController>();
    return Scaffold(
      appBar: AppBar(title: const Text(AppMessages.uploadTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Spacing.md),
        child: ConstrainedContent(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                OutlinedButton.icon(
                  onPressed: upload.isUploading ? null : upload.pickFile,
                  icon: const Icon(Icons.video_file_outlined),
                  label: Text(upload.file?.name ?? AppMessages.pickVideo),
                ),
                const SizedBox(height: Spacing.md),
                AppTextField(
                  controller: _title,
                  label: AppMessages.titleLabel,
                  validator: validateVideoTitle,
                  maxLength: TextLimits.videoTitleMax,
                ),
                const SizedBox(height: Spacing.sm),
                AppTextField(
                  controller: _description,
                  label: AppMessages.descriptionLabel,
                  maxLines: 4,
                  maxLength: TextLimits.videoDescriptionMax,
                  textInputAction: TextInputAction.newline,
                ),
                if (upload.isUploading) ...[
                  LinearProgressIndicator(value: upload.progress),
                  const SizedBox(height: Spacing.md),
                ],
                SubmitButton(label: AppMessages.uploadSubmit, isLoading: upload.isUploading, onPressed: _submit),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
