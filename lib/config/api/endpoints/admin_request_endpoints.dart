class AdminRequestEndpoints {
  const AdminRequestEndpoints._();

  static const String root = '/admin-requests';
  static String byId(String requestId) => '/admin-requests/${Uri.encodeComponent(requestId)}';
  static String decision(String requestId) => '${byId(requestId)}/decision';
}
