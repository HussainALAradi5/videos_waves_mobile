import '../../../enums/users/user/gender.dart';

class RegisterRequestDto {
  const RegisterRequestDto({required this.userName, required this.email, required this.password, required this.gender});

  final String userName;
  final String email;
  final String password;
  final Gender gender;

  Map<String, Object> toJson() => {'userName': userName, 'email': email, 'password': password, 'gender': gender.wire};
}
