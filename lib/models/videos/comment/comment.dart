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
    this.parentId,
    this.isVideoOwner = false,
    this.isEdited = false,
    this.isPendingApproval = false,
    this.repliesCount = 0,
  });

  factory Comment.fromJson(JsonMap json) => Comment(
        id: json['id'] as String,
        code: json['code'] as String,
        videoId: json['videoId'] as String,
        parentId: json['parentId'] as String?,
        content: json['content'] as String,
        author: PublicUser.fromJson(json['author'] as JsonMap),
        isVideoOwner: json['isVideoOwner'] as bool? ?? false,
        isEdited: json['isEdited'] as bool? ?? false,
        isPendingApproval: json['isPendingApproval'] as bool? ?? false,
        repliesCount: json['repliesCount'] as int? ?? 0,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  @override
  final String id;
  @override
  final String code;
  final String videoId;
  final String? parentId;
  final String content;
  final PublicUser author;

  /// The author owns the video: shows the Owner badge.
  final bool isVideoOwner;
  final bool isEdited;

  /// From a restricted account: visible only to its author and the video owner until approved.
  final bool isPendingApproval;
  final int repliesCount;
  @override
  final DateTime createdAt;

  Comment copyWith({String? content, bool? isEdited, bool? isPendingApproval, int? repliesCount}) => Comment(
        id: id,
        code: code,
        videoId: videoId,
        parentId: parentId,
        content: content ?? this.content,
        author: author,
        isVideoOwner: isVideoOwner,
        isEdited: isEdited ?? this.isEdited,
        isPendingApproval: isPendingApproval ?? this.isPendingApproval,
        repliesCount: repliesCount ?? this.repliesCount,
        createdAt: createdAt,
      );
}
