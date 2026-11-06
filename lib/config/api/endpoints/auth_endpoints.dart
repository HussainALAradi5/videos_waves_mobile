/// Mirrors the server routes in `constants/common/routes.constants.ts` (server repository).
class AuthEndpoints {
  const AuthEndpoints._();

  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String refresh = '/auth/refresh';
  static const String logout = '/auth/logout';
  static const String logoutAll = '/auth/logout-all';
}
