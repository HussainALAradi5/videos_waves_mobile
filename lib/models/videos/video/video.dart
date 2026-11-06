import '../../base/base_model.dart';
import '../../common/json_map.dart';
import '../../users/user/public_user.dart';

class Video with BaseModel {
  const Video({
    required this.id,
    required this.code,
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.owner,
    required this.likesCount,
    required this.commentsCount,
    required this.viewsCount,
    required this.isLiked,
    required this.createdAt,
  });

  factory Video.fromJson(JsonMap json) => Video(
        id: json['id'] as String,
        code: json['code'] as String,
        title: json['title'] as String,
        description: json['description'] as String? ?? '',
        videoUrl: json['videoUrl'] as String,
        owner: PublicUser.fromJson(json['owner'] as JsonMap),
        likesCount: json['likesCount'] as int,
        commentsCount: json['commentsCount'] as int,
        viewsCount: json['viewsCount'] as int,
        isLiked: json['isLiked'] as bool? ?? false,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  @override
  final String id;
  @override
  final String code;
  final String title;
  final String description;
  final String videoUrl;
  final PublicUser owner;
  final int likesCount;
  final int commentsCount;
  final int viewsCount;
  final bool isLiked;
  @override
  final DateTime createdAt;

  Video copyWith({bool? isLiked, int? likesCount, int? commentsCount, int? viewsCount}) => Video(
        id: id,
        code: code,
        title: title,
        description: description,
        videoUrl: videoUrl,
        owner: owner,
        likesCount: likesCount ?? this.likesCount,
        commentsCount: commentsCount ?? this.commentsCount,
        viewsCount: viewsCount ?? this.viewsCount,
        isLiked: isLiked ?? this.isLiked,
        createdAt: createdAt,
      );
}
