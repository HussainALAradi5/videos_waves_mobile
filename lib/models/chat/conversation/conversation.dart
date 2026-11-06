import '../../../enums/chat/conversation/chat_background.dart';
import '../../../enums/chat/conversation/conversation_type.dart';
import '../../../enums/chat/conversation/member_role.dart';
import '../../../enums/chat/conversation/member_status.dart';
import '../../base/base_model.dart';
import '../../common/json_map.dart';
import 'chat_member.dart';

class Conversation with BaseModel {
  const Conversation({
    required this.id,
    required this.code,
    required this.type,
    required this.members,
    required this.membersCount,
    required this.myRole,
    required this.myStatus,
    required this.unreadCount,
    required this.isMuted,
    required this.createdAt,
    this.background = ChatBackground.none,
    this.title,
    this.lastPreview,
    this.lastSenderId,
    this.lastMessageAt,
  });

  factory Conversation.fromJson(JsonMap json) {
    final me = json['me'] as JsonMap;
    final last = json['lastMessage'] as JsonMap?;
    return Conversation(
      id: json['id'] as String,
      code: json['code'] as String,
      type: ConversationType.fromWire(json['type'] as String),
      title: json['title'] as String?,
      members: (json['members'] as List<dynamic>).cast<JsonMap>().map(ChatMember.fromJson).toList(),
      membersCount: json['membersCount'] as int,
      myRole: MemberRole.fromWire(me['role'] as String),
      myStatus: MemberStatus.fromWire(me['status'] as String),
      unreadCount: me['unreadCount'] as int,
      isMuted: me['isMuted'] as bool,
      background: ChatBackground.fromWire(me['background'] as String?),
      lastPreview: last?['preview'] as String?,
      lastSenderId: last?['senderId'] as String?,
      lastMessageAt: json['lastMessageAt'] == null ? null : DateTime.parse(json['lastMessageAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  @override
  final String id;
  @override
  final String code;
  final ConversationType type;
  final String? title;

  /// Everyone except you.
  final List<ChatMember> members;
  final int membersCount;
  final MemberRole myRole;
  final MemberStatus myStatus;
  final int unreadCount;
  final bool isMuted;

  /// Your own wallpaper for this chat; nobody else sees it.
  final ChatBackground background;
  final String? lastPreview;
  final String? lastSenderId;
  final DateTime? lastMessageAt;
  @override
  final DateTime createdAt;

  bool get isGroup => type == ConversationType.group;
  ChatMember? get partner => isGroup || members.isEmpty ? null : members.first;
  String get displayTitle => isGroup ? (title ?? '') : (partner?.user.userName ?? '');


  bool get isRequest => myStatus == MemberStatus.request;

  Conversation copyWith({List<ChatMember>? members, MemberStatus? myStatus, bool? isMuted, int? unreadCount}) => Conversation(
        id: id,
        code: code,
        type: type,
        title: title,
        members: members ?? this.members,
        membersCount: membersCount,
        myRole: myRole,
        myStatus: myStatus ?? this.myStatus,
        unreadCount: unreadCount ?? this.unreadCount,
        isMuted: isMuted ?? this.isMuted,
        background: background,
        createdAt: createdAt,
        lastPreview: lastPreview,
        lastSenderId: lastSenderId,
        lastMessageAt: lastMessageAt,
      );
}
