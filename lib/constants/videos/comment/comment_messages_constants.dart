class CommentMessages {
  const CommentMessages._();

  static const String reply = 'Reply';
  static const String replyHint = 'Write a reply';
  static const String hideReplies = 'Hide replies';
  static const String edited = 'Edited';
  static const String edit = 'Edit';
  static const String delete = 'Delete';
  static const String deleted = 'Comment deleted';
  static const String approve = 'Approve';
  static const String restricted = 'Restricted · only you and the author can see this';
  static const String actions = 'Comment actions';
  static String viewReplies(int count) => count == 1 ? 'View 1 reply' : 'View $count replies';
}
