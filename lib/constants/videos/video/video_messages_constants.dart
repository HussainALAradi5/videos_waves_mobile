class VideoMessages {
  const VideoMessages._();

  static const String forYou = 'For you';
  static const String discover = 'Discover';
  static const String following = 'Following';
  static const String noFollowingVideos = 'Follow people to see their waves here.';
  static const String editVideo = 'Edit video';
  static const String deleteVideo = 'Delete video';
  static const String deleteVideoTitle = 'Delete this video?';
  static const String deleteVideoBody = 'Its comments and likes are removed too. This cannot be undone.';
  static const String videoDeleted = 'Video deleted';
  static const String videoSaved = 'Video updated';
  static const String uploadTitle = 'Upload videos';
  static const String uploadHint = 'Pick up to 10 videos. Each uploads straight away; add titles, then publish.';
  static const String chooseVideos = 'Choose videos';
  static const String addMore = 'Add more';
  static const String publish = 'Publish';
  static const String retry = 'Retry';
  static const String remove = 'Remove';
  static const String skippedFiles = 'Some files were skipped: the limit is 10 at a time.';
  static String published(int count) => count == 1 ? '1 video published' : '$count videos published';
}
