import '../../../enums/users/user/gender.dart';
import '../../common/json_map.dart';

class PublicUser {
  const PublicUser({required this.id, required this.userName, this.avatarUrl, this.gender});

  factory PublicUser.fromJson(JsonMap json) => PublicUser(
        id: json['id'] as String,
        userName: json['userName'] as String,
        avatarUrl: json['avatarUrl'] as String?,
        gender: json['gender'] == null ? null : Gender.fromWire(json['gender'] as String),
      );

  final String id;
  final String userName;

  /// null: show the standard avatar for [gender].
  final String? avatarUrl;
  final Gender? gender;
}
