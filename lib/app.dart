import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'config/routes/app_router.dart';
import 'config/theme/app_theme.dart';
import 'constants/common/messages_constants.dart';
import 'controllers/users/settings/settings_controller.dart';
import 'controllers/videos/video/video_feed_controller.dart';
import 'globals/app_dependencies.dart';

class VideosWavesApp extends StatefulWidget {
  const VideosWavesApp({super.key, required this.dependencies});

  final AppDependencies dependencies;

  @override
  State<VideosWavesApp> createState() => _VideosWavesAppState();
}

class _VideosWavesAppState extends State<VideosWavesApp> {
  final GlobalKey<ScaffoldMessengerState> _messengerKey = GlobalKey<ScaffoldMessengerState>();
  late final GoRouter _router = createAppRouter(widget.dependencies.authController);

  @override
  void initState() {
    super.initState();
    widget.dependencies.authController.addListener(_onAuthChanged);
  }

  @override
  void dispose() {
    widget.dependencies.authController.removeListener(_onAuthChanged);
    _router.dispose();
    super.dispose();
  }

  void _onAuthChanged() {
    final auth = widget.dependencies.authController;
    if (!auth.hasSessionExpired) return;
    auth.consumeSessionExpired();
    _messengerKey.currentState?.showSnackBar(const SnackBar(content: Text(AppMessages.sessionExpired)));
  }

  @override
  Widget build(BuildContext context) {
    final dependencies = widget.dependencies;
    return MultiProvider(
      providers: [
        Provider.value(value: dependencies),
        ChangeNotifierProvider.value(value: dependencies.authController),
        ChangeNotifierProvider.value(value: dependencies.settingsController),
        ChangeNotifierProvider.value(value: dependencies.chatSocketController),
        ChangeNotifierProvider(create: (_) => VideoFeedController(dependencies.videoService)..loadFirstPage()),
      ],
      child: Consumer<SettingsController>(
        builder: (context, settings, _) => MaterialApp.router(
          title: AppMessages.appName,
          debugShowCheckedModeBanner: false,
          scaffoldMessengerKey: _messengerKey,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: settings.themeMode,
          routerConfig: _router,
        ),
      ),
    );
  }
}
