import '../../../../dtos/users/auth/auth_session_dto.dart';
import '../../../../dtos/users/auth/login_request_dto.dart';
import '../../../../dtos/users/auth/register_request_dto.dart';
import '../../../../models/users/user/user.dart';

abstract interface class AuthServiceInterface {
  Future<AuthSessionDto> login(LoginRequestDto dto);
  Future<AuthSessionDto> register(RegisterRequestDto dto);
  Future<User> me();
  Future<void> logout();
}
