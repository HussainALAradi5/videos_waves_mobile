class LoginRequestDto {
  const LoginRequestDto({required this.identifier, required this.password});

  final String identifier;
  final String password;

  Map<String, Object> toJson() => {'identifier': identifier, 'password': password};
}
