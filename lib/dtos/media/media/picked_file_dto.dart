import 'dart:typed_data';

/// A file chosen on the device: a path on mobile and desktop, bytes on the web.
class PickedFileDto {
  const PickedFileDto({required this.name, required this.mimeType, required this.sizeBytes, this.path, this.bytes});

  final String name;
  final String mimeType;
  final int sizeBytes;
  final String? path;
  final Uint8List? bytes;
}
