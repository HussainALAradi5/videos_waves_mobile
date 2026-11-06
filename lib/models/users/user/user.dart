import '../../../enums/users/roles/role.dart';
import '../../base/base_model.dart';
import '../../common/json_map.dart';

class User with BaseModel {
  const User({
    required this.id,
    required this.code,
    required this.userName,
    required this.email,
    required this.role,
    required this.createdAt,
    this.image,
  });

  factory User.fromJson(JsonMap json) => User(
        id: json['id'] as String,
        code: json['code'] as String,
        userName: json['userName'] as String,
        email: json['email'] as String,
        role: Role.fromWire(json['role'] as String),
        image: json['image'] as String?,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  @override
  final String id;
  @override
  final String code;
  final String userName;
  final String email;
  final Role role;
  final String? image;
  @override
  final DateTime createdAt;

  bool get isAdmin => role == Role.admin;
}
