import '../../../enums/users/user/gender.dart';

class RegisterRequestDto {
  const RegisterRequestDto({required this.userName, required this.email, required this.password, required this.gender, this.phone});

  final String userName;
  final String email;
  final String password;
  final Gender gender;

  /// Optional and private.
  final String? phone;

  Map<String, Object> toJson() => {
        'userName': userName,
        'email': email,
        if (phone != null && phone!.isNotEmpty) 'phone': phone!,
        'password': password,
        'gender': gender.wire,
      };
}
