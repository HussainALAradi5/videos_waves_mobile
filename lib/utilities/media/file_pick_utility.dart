import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

import '../../dtos/media/media/picked_file_dto.dart';
import 'mime_type_utility.dart';

/// Opens the system picker for several files; the web has no paths, so bytes are read instead.
Future<List<PickedFileDto>> pickFiles(FileType type) async {
  final picked = await FilePicker.pickFiles(type: type);
  return Future.wait(picked.map(toPickedFile));
}

Future<PickedFileDto> toPickedFile(PlatformFile file) async {
  final path = kIsWeb ? null : file.path;
  return PickedFileDto(
    name: file.name,
    mimeType: mimeTypeOf(file.name),
    sizeBytes: await file.length() ?? 0,
    path: path,
    bytes: path == null ? await file.readAsBytes() : null,
  );
}
