import '../../../enums/users/roles/role.dart';
import '../../common/json_map.dart';
import '../user/public_user.dart';

/// A public profile with the viewer relations to it.
class Profile {
  const Profile({
    required this.user,
    required this.bio,
    required this.followersCount,
    required this.followingCount,
    required this.videosCount,
    required this.isMe,
    required this.isFollowing,
    required this.followsYou,
    required this.isBlocked,
    required this.isRestricted,
    this.role = Role.user,
    this.isActive = true,
  });

  factory Profile.fromJson(JsonMap json) => Profile(
        user: PublicUser.fromJson(json),
        bio: json['bio'] as String? ?? '',
        followersCount: json['followersCount'] as int,
        followingCount: json['followingCount'] as int,
        videosCount: json['videosCount'] as int,
        isMe: json['isMe'] as bool,
        isFollowing: json['isFollowing'] as bool,
        followsYou: json['followsYou'] as bool,
        isBlocked: json['isBlocked'] as bool,
        isRestricted: json['isRestricted'] as bool,
        role: Role.fromWire(json['role'] as String? ?? Role.user.wireValue),
        isActive: json['isActive'] as bool? ?? true,
      );

  final PublicUser user;
  final String bio;
  final int followersCount;
  final int followingCount;
  final int videosCount;
  final bool isMe;
  final bool isFollowing;
  final bool followsYou;
  final bool isBlocked;
  final bool isRestricted;
  final Role role;

  /// False when an admin deactivated the account; only admins can open such a profile.
  final bool isActive;

  Profile copyWith({bool? isFollowing, int? followersCount, bool? isBlocked, bool? isRestricted}) => Profile(
        user: user,
        bio: bio,
        followersCount: followersCount ?? this.followersCount,
        followingCount: followingCount,
        videosCount: videosCount,
        isMe: isMe,
        isFollowing: isFollowing ?? this.isFollowing,
        followsYou: followsYou,
        isBlocked: isBlocked ?? this.isBlocked,
        isRestricted: isRestricted ?? this.isRestricted,
        role: role,
        isActive: isActive,
      );
}
