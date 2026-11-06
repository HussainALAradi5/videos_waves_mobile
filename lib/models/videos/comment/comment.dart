import '../../base/base_model.dart';
import '../../common/json_map.dart';
import '../../users/user/public_user.dart';

class Comment with BaseModel {
  const Comment({
    required this.id,
    required this.code,
    required this.videoId,
    required this.content,
    required this.author,
    required this.createdAt,
  });

  factory Comment.fromJson(JsonMap json) => Comment(
        id: json['id'] as String,
        code: json['code'] as String,
        videoId: json['videoId'] as String,
        content: json['content'] as String,
        author: PublicUser.fromJson(json['author'] as JsonMap),
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  @override
  final String id;
  @override
  final String code;
  final String videoId;
  final String content;
  final PublicUser author;
  @override
  final DateTime createdAt;
}
