import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app.dart';
import 'globals/app_dependencies.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // On the web demo, right-click opens the app's own menus (message and chat actions), not the browser's.
  if (kIsWeb) await BrowserContextMenu.disableContextMenu();
  final dependencies = AppDependencies.create();
  // Restore the stored session first so the router's guards see the real auth state.
  await dependencies.authController.restore();
  runApp(VideosWavesApp(dependencies: dependencies));
}
