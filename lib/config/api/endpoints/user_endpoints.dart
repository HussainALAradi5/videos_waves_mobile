class UserEndpoints {
  const UserEndpoints._();

  static const String root = '/users';
  static const String me = '/users/me';
  static const String mePassword = '/users/me/password';
  static const String meAvatar = '/users/me/avatar';
  static const String meSettings = '/users/me/settings';
  static const String search = '/users/search';
  static const String meFollowRequests = '/users/me/follow-requests';

  static String followRequest(String userName) => '$meFollowRequests/${Uri.encodeComponent(userName)}';

  static String profile(String userName) => '/users/${Uri.encodeComponent(userName)}';
  static String follow(String userName) => '${profile(userName)}/follow';
  static String followers(String userName) => '${profile(userName)}/followers';
  static String following(String userName) => '${profile(userName)}/following';
  static String block(String userName) => '${profile(userName)}/block';
  static String restrict(String userName) => '${profile(userName)}/restrict';
  static String status(String userName) => '${profile(userName)}/status';
  static String role(String userName) => '${profile(userName)}/role';
}
