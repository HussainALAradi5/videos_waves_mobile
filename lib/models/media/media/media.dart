import '../../base/base_model.dart';
import '../../common/json_map.dart';

class Media with BaseModel {
  const Media({
    required this.id,
    required this.code,
    required this.url,
    required this.mimeType,
    required this.sizeBytes,
    required this.originalName,
    required this.createdAt,
    this.thumbnailUrl,
    this.durationSeconds,
  });

  factory Media.fromJson(JsonMap json) => Media(
        id: json['id'] as String,
        code: json['code'] as String,
        url: json['url'] as String,
        thumbnailUrl: json['thumbnailUrl'] as String?,
        mimeType: json['mimeType'] as String,
        sizeBytes: json['sizeBytes'] as int,
        durationSeconds: (json['durationSeconds'] as num?)?.toDouble(),
        originalName: json['originalName'] as String? ?? '',
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  @override
  final String id;
  @override
  final String code;

  /// Public CDN URL, or a short-lived signed URL for private media.
  final String url;
  final String? thumbnailUrl;
  final String mimeType;
  final int sizeBytes;
  final double? durationSeconds;
  final String originalName;
  @override
  final DateTime createdAt;

  bool get isImage => mimeType.startsWith('image/');
  bool get isVideo => mimeType.startsWith('video/');
}
