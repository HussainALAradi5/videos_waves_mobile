import '../../../enums/users/roles/role.dart';
import '../../../enums/users/user/gender.dart';
import '../../base/base_model.dart';
import '../../common/json_map.dart';
import 'public_user.dart';

class User with BaseModel {
  const User({
    required this.id,
    required this.code,
    required this.userName,
    required this.email,
    required this.role,
    required this.createdAt,
    this.gender,
    this.avatarUrl,
    this.bio = '',
    this.followersCount = 0,
    this.followingCount = 0,
    this.videosCount = 0,
    this.isActive = true,
    this.phone,
  });

  factory User.fromJson(JsonMap json) => User(
        id: json['id'] as String,
        code: json['code'] as String,
        userName: json['userName'] as String,
        email: json['email'] as String,
        phone: json['phone'] as String?,
        role: Role.fromWire(json['role'] as String),
        gender: json['gender'] == null ? null : Gender.fromWire(json['gender'] as String),
        avatarUrl: json['avatarUrl'] as String?,
        bio: json['bio'] as String? ?? '',
        followersCount: json['followersCount'] as int? ?? 0,
        followingCount: json['followingCount'] as int? ?? 0,
        videosCount: json['videosCount'] as int? ?? 0,
        isActive: json['isActive'] as bool? ?? true,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  @override
  final String id;
  @override
  final String code;
  final String userName;
  final String email;

  /// Private: only the owner and admins see it.
  final String? phone;
  final Role role;
  final Gender? gender;
  final String? avatarUrl;
  final String bio;
  final int followersCount;
  final int followingCount;
  final int videosCount;

  /// False when an admin deactivated the account.
  final bool isActive;
  @override
  final DateTime createdAt;

  bool get isAdmin => role == Role.admin;

  PublicUser get asPublic => PublicUser(id: id, userName: userName, avatarUrl: avatarUrl, gender: gender);
}
