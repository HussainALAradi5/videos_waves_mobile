import '../../common/json_map.dart';
import '../user/public_user.dart';

/// A person in a people list, with whether the viewer follows them.
class UserSummary {
  const UserSummary({required this.user, required this.isFollowing, required this.isMe});

  factory UserSummary.fromJson(JsonMap json) =>
      UserSummary(user: PublicUser.fromJson(json), isFollowing: json['isFollowing'] as bool, isMe: json['isMe'] as bool);

  final PublicUser user;
  final bool isFollowing;
  final bool isMe;

  UserSummary copyWith({bool? isFollowing}) => UserSummary(user: user, isFollowing: isFollowing ?? this.isFollowing, isMe: isMe);
}
