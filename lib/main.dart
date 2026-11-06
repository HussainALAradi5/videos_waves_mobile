import 'package:flutter/material.dart';

import 'app.dart';
import 'globals/app_dependencies.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dependencies = AppDependencies.create();
  // Restore the stored session first so the router's guards see the real auth state.
  await dependencies.authController.restore();
  runApp(VideosWavesApp(dependencies: dependencies));
}
