class RegisterRequestDto {
  const RegisterRequestDto({required this.userName, required this.email, required this.password});

  final String userName;
  final String email;
  final String password;

  Map<String, Object> toJson() => {'userName': userName, 'email': email, 'password': password};
}
