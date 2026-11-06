import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

import '../../../dtos/videos/video/picked_video_dto.dart';
import '../../../interfaces/services/videos/video/video_service_interface.dart';
import '../../../models/videos/video/video.dart';

class VideoUploadController extends ChangeNotifier {
  VideoUploadController(this._videoService);

  final VideoServiceInterface _videoService;

  PickedVideoDto? file;
  double progress = 0;
  bool isUploading = false;

  Future<void> pickFile() async {
    final picked = await FilePicker.pickFile(type: FileType.video);
    if (picked == null) return;
    final path = picked.path;
    // The web has no file paths, so the bytes are read instead.
    file = PickedVideoDto(
      name: picked.name,
      sizeBytes: await picked.length() ?? 0,
      path: path,
      bytes: path == null ? await picked.readAsBytes() : null,
    );
    notifyListeners();
  }

  /// Uploads the picked file; the server validates type and size again.
  Future<Video> upload({required String title, required String description}) async {
    final selected = file;
    if (selected == null) throw StateError('No file selected');
    isUploading = true;
    progress = 0;
    notifyListeners();
    try {
      return await _videoService.upload(
        file: selected,
        title: title.trim(),
        description: description.trim(),
        onProgress: (value) {
          progress = value;
          notifyListeners();
        },
      );
    } finally {
      isUploading = false;
      notifyListeners();
    }
  }
}
