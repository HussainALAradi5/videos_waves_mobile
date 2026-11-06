class MediaMessages {
  const MediaMessages._();

  static const String typeNotAllowed = 'This file type is not allowed here.';
  static const String tooLarge = 'This file is too large.';
  static String fileTooLarge(String name, String limit) => '"$name" is too large. The limit is $limit.';
  static String fileTypeNotAllowed(String name) => '"$name" is not a supported file type here.';
  static const String uploading = 'Uploading';
  static const String failed = 'Upload failed';
  static const String addFiles = 'Add files';
  static const String remove = 'Remove';
}
