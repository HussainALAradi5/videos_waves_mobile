import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/videos/video/video_upload_controller.dart';
import '../../../globals/app_dependencies.dart';
import 'video_upload_form.dart';

class VideoUploadScreen extends StatelessWidget {
  const VideoUploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => VideoUploadController(context.read<AppDependencies>().videoService),
      child: const VideoUploadForm(),
    );
  }
}
