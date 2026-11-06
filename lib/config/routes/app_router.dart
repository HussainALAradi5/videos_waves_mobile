import 'package:go_router/go_router.dart';

import '../../constants/common/routes_constants.dart';
import '../../controllers/users/auth/auth_controller.dart';
import '../../screens/chat/inbox/inbox_screen.dart';
import '../../screens/chat/thread/thread_screen.dart';
import '../../screens/common/home_shell.dart';
import '../../screens/users/admin_requests/admin_requests_screen.dart';
import '../../screens/users/admin_users/admin_users_screen.dart';
import '../../screens/users/auth/login_screen.dart';
import '../../screens/users/auth/register_screen.dart';
import '../../screens/users/profile/profile_screen.dart';
import '../../screens/users/search/user_search_screen.dart';
import '../../screens/users/settings/settings_screen.dart';
import '../../screens/videos/details/video_details_screen.dart';
import '../../screens/videos/feed/video_feed_screen.dart';
import '../../screens/videos/upload/video_upload_screen.dart';
import 'route_guard.dart';

GoRouter createAppRouter(AuthController auth) => GoRouter(
      initialLocation: AppRoutes.feed,
      refreshListenable: auth,
      redirect: (context, state) => resolveRedirect(auth, state.uri),
      routes: [
        ShellRoute(
          builder: (context, state, child) => HomeShell(location: state.uri.path, child: child),
          routes: [
            GoRoute(path: AppRoutes.feed, builder: (_, _) => const VideoFeedScreen()),
            GoRoute(path: AppRoutes.search, builder: (_, _) => const UserSearchScreen()),
            GoRoute(path: AppRoutes.upload, builder: (_, _) => const VideoUploadScreen()),
            GoRoute(path: AppRoutes.messages, builder: (_, _) => const InboxScreen()),
            GoRoute(path: AppRoutes.profile, builder: (_, _) => const ProfileScreen()),
          ],
        ),
        GoRoute(
          path: AppRoutes.threadPattern,
          builder: (_, state) => ThreadScreen(conversationId: state.pathParameters[AppRoutes.conversationIdParam]!),
        ),
        GoRoute(
          path: AppRoutes.userPattern,
          builder: (_, state) => ProfileScreen(userName: state.pathParameters[AppRoutes.userNameParam]),
        ),
        GoRoute(
          path: AppRoutes.videoPattern,
          builder: (_, state) => VideoDetailsScreen(videoId: state.pathParameters[AppRoutes.videoIdParam]!),
        ),
        GoRoute(path: AppRoutes.settings, builder: (_, _) => const SettingsScreen()),
        GoRoute(path: AppRoutes.adminRequests, builder: (_, _) => const AdminRequestsScreen()),
        GoRoute(path: AppRoutes.adminUsers, builder: (_, _) => const AdminUsersScreen()),
        GoRoute(path: AppRoutes.login, builder: (_, _) => const LoginScreen()),
        GoRoute(path: AppRoutes.register, builder: (_, _) => const RegisterScreen()),
      ],
    );
