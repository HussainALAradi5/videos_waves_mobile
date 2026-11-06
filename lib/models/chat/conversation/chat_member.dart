import '../../../enums/chat/conversation/member_role.dart';
import '../../common/json_map.dart';
import '../../users/user/public_user.dart';

class ChatMember {
  const ChatMember({required this.user, required this.role, this.lastReadAt, this.isOnline});

  factory ChatMember.fromJson(JsonMap json) => ChatMember(
        user: PublicUser.fromJson(json['user'] as JsonMap),
        role: MemberRole.fromWire(json['role'] as String),
        lastReadAt: json['lastReadAt'] == null ? null : DateTime.parse(json['lastReadAt'] as String),
        isOnline: json['isOnline'] as bool?,
      );

  final PublicUser user;
  final MemberRole role;

  /// null when unknown or hidden from you.
  final DateTime? lastReadAt;

  /// null when hidden from you.
  final bool? isOnline;

  ChatMember copyWith({DateTime? lastReadAt, bool? isOnline}) =>
      ChatMember(user: user, role: role, lastReadAt: lastReadAt ?? this.lastReadAt, isOnline: isOnline ?? this.isOnline);
}
