import '../../../dtos/media/media/picked_file_dto.dart';
import '../../../enums/media/upload/upload_status.dart';
import '../media/media.dart';

/// One file in an upload queue; the queue controller owns and mutates it.
class UploadItem {
  UploadItem(this.id, this.file);

  final int id;
  final PickedFileDto file;
  UploadStatus status = UploadStatus.uploading;
  double progress = 0;
  Media? media;
  String? error;

  bool get isDone => status == UploadStatus.done;
  bool get isImage => file.mimeType.startsWith('image/');
  bool get isVideo => file.mimeType.startsWith('video/');
}
