import 'dart:typed_data';

/// A video chosen with the file picker: a path on mobile, bytes on the web.
class PickedVideoDto {
  const PickedVideoDto({required this.name, required this.sizeBytes, this.path, this.bytes});

  final String name;
  final int sizeBytes;
  final String? path;
  final Uint8List? bytes;
}
