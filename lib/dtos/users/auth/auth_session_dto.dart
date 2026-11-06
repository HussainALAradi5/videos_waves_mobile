import '../../../models/common/json_map.dart';
import '../../../models/users/user/user.dart';

class AuthSessionDto {
  const AuthSessionDto({required this.accessToken, required this.refreshToken, required this.user});

  factory AuthSessionDto.fromJson(JsonMap json) => AuthSessionDto(
        accessToken: json['accessToken'] as String,
        refreshToken: json['refreshToken'] as String,
        user: User.fromJson(json['user'] as JsonMap),
      );

  final String accessToken;
  final String refreshToken;
  final User user;
}
