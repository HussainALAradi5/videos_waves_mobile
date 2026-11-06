import '../../../config/api/endpoints/auth_endpoints.dart';
import '../../../config/api/endpoints/user_endpoints.dart';
import '../../../dtos/users/auth/auth_session_dto.dart';
import '../../../dtos/users/auth/login_request_dto.dart';
import '../../../dtos/users/auth/register_request_dto.dart';
import '../../../interfaces/services/users/auth/auth_service_interface.dart';
import '../../../models/users/user/user.dart';
import '../../api/api_client.dart';

class AuthService implements AuthServiceInterface {
  const AuthService(this._client);

  final ApiClient _client;

  @override
  Future<AuthSessionDto> login(LoginRequestDto dto) =>
      _client.post(AuthEndpoints.login, AuthSessionDto.fromJson, body: dto.toJson());

  @override
  Future<AuthSessionDto> register(RegisterRequestDto dto) =>
      _client.post(AuthEndpoints.register, AuthSessionDto.fromJson, body: dto.toJson());

  @override
  Future<User> me() => _client.get(UserEndpoints.me, User.fromJson);

  @override
  Future<void> logout() => _client.post(AuthEndpoints.logout, ignoreBody);
}
