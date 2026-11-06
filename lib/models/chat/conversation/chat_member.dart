import '../../../enums/chat/conversation/member_role.dart';
import '../../../enums/chat/realtime/presence_state.dart';
import '../../common/json_map.dart';
import '../../users/user/public_user.dart';

class ChatMember {
  const ChatMember({required this.user, required this.role, this.lastReadAt, this.isOnline, this.presence, this.statusText});

  factory ChatMember.fromJson(JsonMap json) => ChatMember(
        user: PublicUser.fromJson(json['user'] as JsonMap),
        role: MemberRole.fromWire(json['role'] as String),
        lastReadAt: json['lastReadAt'] == null ? null : DateTime.parse(json['lastReadAt'] as String),
        isOnline: json['isOnline'] as bool?,
        presence: PresenceState.fromWire(json['presence'] as String?),
        statusText: json['statusText'] as String?,
      );

  final PublicUser user;
  final MemberRole role;

  /// null when unknown or hidden from you.
  final DateTime? lastReadAt;

  /// null when hidden from you.
  final bool? isOnline;

  /// Online, away, busy, or offline; null when hidden from you.
  final PresenceState? presence;

  /// Their custom status line; null when hidden or empty.
  final String? statusText;

  ChatMember copyWith({DateTime? lastReadAt, bool? isOnline, PresenceState? presence, String? statusText}) => ChatMember(
        user: user,
        role: role,
        lastReadAt: lastReadAt ?? this.lastReadAt,
        isOnline: isOnline ?? this.isOnline,
        presence: presence ?? this.presence,
        statusText: statusText ?? this.statusText,
      );
}
