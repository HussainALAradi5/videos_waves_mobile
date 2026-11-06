import '../../common/json_map.dart';
import '../user/public_user.dart';

/// A person in a people list, with whether the viewer follows them (or is waiting on a request).
class UserSummary {
  const UserSummary({required this.user, required this.isFollowing, required this.isMe, this.isRequested = false});

  factory UserSummary.fromJson(JsonMap json) => UserSummary(
        user: PublicUser.fromJson(json),
        isFollowing: json['isFollowing'] as bool,
        isRequested: json['isRequested'] as bool? ?? false,
        isMe: json['isMe'] as bool,
      );

  final PublicUser user;
  final bool isFollowing;
  final bool isRequested;
  final bool isMe;

  UserSummary copyWith({bool? isFollowing, bool? isRequested}) =>
      UserSummary(user: user, isFollowing: isFollowing ?? this.isFollowing, isRequested: isRequested ?? this.isRequested, isMe: isMe);
}
