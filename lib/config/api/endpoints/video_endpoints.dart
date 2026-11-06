class VideoEndpoints {
  const VideoEndpoints._();

  static const String root = '/videos';
  static String byId(String videoId) => '/videos/${Uri.encodeComponent(videoId)}';
  static String views(String videoId) => '${byId(videoId)}/views';
  static String like(String videoId) => '${byId(videoId)}/like';
  static String comments(String videoId) => '${byId(videoId)}/comments';
  static String comment(String videoId, String commentId) => '${comments(videoId)}/${Uri.encodeComponent(commentId)}';
  static String replies(String videoId, String commentId) => '${comment(videoId, commentId)}/replies';
  static String restore(String videoId, String commentId) => '${comment(videoId, commentId)}/restore';
  static String approve(String videoId, String commentId) => '${comment(videoId, commentId)}/approve';
}
