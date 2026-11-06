import '../../common/json_map.dart';

/// What the server returns before a direct upload to the storage provider.
class UploadSignature {
  const UploadSignature({
    required this.uploadUrl,
    required this.publicKey,
    required this.token,
    required this.expire,
    required this.signature,
    required this.folder,
    required this.isPrivateFile,
    required this.maxBytes,
    required this.mimeTypes,
  });

  factory UploadSignature.fromJson(JsonMap json) => UploadSignature(
        uploadUrl: json['uploadUrl'] as String,
        publicKey: json['publicKey'] as String,
        token: json['token'] as String,
        expire: json['expire'] as int,
        signature: json['signature'] as String,
        folder: json['folder'] as String,
        isPrivateFile: json['isPrivateFile'] as bool,
        maxBytes: json['maxBytes'] as int,
        mimeTypes: (json['mimeTypes'] as List<dynamic>).cast<String>(),
      );

  final String uploadUrl;
  final String publicKey;
  final String token;
  final int expire;
  final String signature;
  final String folder;
  final bool isPrivateFile;
  final int maxBytes;
  final List<String> mimeTypes;
}
