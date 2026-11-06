import '../../common/json_map.dart';

class PublicUser {
  const PublicUser({required this.id, required this.userName, this.image});

  factory PublicUser.fromJson(JsonMap json) => PublicUser(
        id: json['id'] as String,
        userName: json['userName'] as String,
        image: json['image'] as String?,
      );

  final String id;
  final String userName;
  final String? image;
}
