import '../../constants/common/routes_constants.dart';
import '../../controllers/users/auth/auth_controller.dart';
import '../../enums/common/auth_status.dart';

/// Accepts only in-app paths, so a crafted `redirect` cannot leave the app's routes.
String safeRedirect(String? value) =>
    value != null && value.startsWith('/') && !value.startsWith('//') ? value : AppRoutes.feed;

/// Client-side guard for protected screens. The API still enforces every permission.
String? resolveRedirect(AuthController auth, Uri uri) {
  if (auth.status == AuthStatus.unknown) return null;
  final path = uri.path;
  final isAuthScreen = path == AppRoutes.login || path == AppRoutes.register;
  final isProtected = AppRoutes.protectedPrefixes.any(path.startsWith);

  if (isProtected && !auth.isAuthenticated) {
    return '${AppRoutes.login}?${AppRoutes.redirectParam}=${Uri.encodeComponent(uri.toString())}';
  }
  if (path.startsWith(AppRoutes.adminPrefix) && !auth.isAdmin) return AppRoutes.feed;
  if (isAuthScreen && auth.isAuthenticated) return safeRedirect(uri.queryParameters[AppRoutes.redirectParam]);
  return null;
}
