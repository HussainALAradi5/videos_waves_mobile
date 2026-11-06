/// A file the app refused before uploading (too large or the wrong type); [message] names the file and the limit.
class UploadRejectedException implements Exception {
  const UploadRejectedException(this.message);

  final String message;

  @override
  String toString() => message;
}
