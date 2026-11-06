import '../../../enums/chat/message/message_kind.dart';
import '../../common/json_map.dart';
import '../../media/media/media.dart';
import '../../users/user/public_user.dart';
import 'reaction_count.dart';

class Message {
  const Message({
    required this.id,
    required this.conversationId,
    required this.sender,
    required this.kind,
    required this.attachments,
    required this.reactions,
    required this.isEdited,
    required this.isUnsent,
    required this.createdAt,
    this.body,
    this.replyToId,
    this.replyToSender,
    this.replyToPreview,
    this.sharedVideoId,
    this.sharedVideoTitle,
    this.systemAction,
    this.systemTargetName,
    this.myReaction,
  });

  factory Message.fromJson(JsonMap json) {
    final reply = json['replyTo'] as JsonMap?;
    final video = json['sharedVideo'] as JsonMap?;
    final target = json['systemTarget'] as JsonMap?;
    return Message(
      id: json['id'] as String,
      conversationId: json['conversationId'] as String,
      sender: PublicUser.fromJson(json['sender'] as JsonMap),
      kind: MessageKind.fromWire(json['kind'] as String),
      body: json['body'] as String?,
      attachments: (json['attachments'] as List<dynamic>).cast<JsonMap>().map(Media.fromJson).toList(),
      replyToId: reply?['id'] as String?,
      replyToSender: reply?['senderUserName'] as String?,
      replyToPreview: reply?['preview'] as String?,
      sharedVideoId: video?['id'] as String?,
      sharedVideoTitle: video?['title'] as String?,
      systemAction: json['systemAction'] as String?,
      systemTargetName: target?['userName'] as String?,
      reactions: (json['reactions'] as List<dynamic>).cast<JsonMap>().map(ReactionCount.fromJson).toList(),
      myReaction: json['myReaction'] as String?,
      isEdited: json['isEdited'] as bool,
      isUnsent: json['isUnsent'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  final String id;
  final String conversationId;
  final PublicUser sender;
  final MessageKind kind;
  final String? body;
  final List<Media> attachments;
  final String? replyToId;
  final String? replyToSender;
  final String? replyToPreview;
  final String? sharedVideoId;
  final String? sharedVideoTitle;
  final String? systemAction;
  final String? systemTargetName;
  final List<ReactionCount> reactions;
  final String? myReaction;
  final bool isEdited;
  final bool isUnsent;
  final DateTime createdAt;

  bool get isSystem => kind == MessageKind.system;

  /// Short text for reply quotes and previews.
  String get preview => body ?? (attachments.isNotEmpty ? attachments.first.originalName : sharedVideoTitle ?? '');

  Message copyWith({List<ReactionCount>? reactions, String? myReaction, bool clearMyReaction = false, bool? isUnsent}) => Message(
        id: id,
        conversationId: conversationId,
        sender: sender,
        kind: kind,
        body: isUnsent == true ? null : body,
        attachments: isUnsent == true ? const [] : attachments,
        replyToId: replyToId,
        replyToSender: replyToSender,
        replyToPreview: replyToPreview,
        sharedVideoId: sharedVideoId,
        sharedVideoTitle: sharedVideoTitle,
        systemAction: systemAction,
        systemTargetName: systemTargetName,
        reactions: reactions ?? this.reactions,
        myReaction: clearMyReaction ? null : myReaction ?? this.myReaction,
        isEdited: isEdited,
        isUnsent: isUnsent ?? this.isUnsent,
        createdAt: createdAt,
      );
}
