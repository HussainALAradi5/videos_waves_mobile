import 'package:flutter/material.dart';

import '../../../constants/common/ui_constants.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key, required this.userName, this.imageUrl, this.radius = Layout.avatarSmall});

  final String userName;
  final String? imageUrl;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final initial = userName.isEmpty ? '?' : userName.characters.first.toUpperCase();
    return CircleAvatar(
      radius: radius,
      backgroundColor: colors.primaryContainer,
      foregroundImage: imageUrl == null ? null : NetworkImage(imageUrl!),
      child: Text(initial, style: TextStyle(color: colors.onPrimaryContainer)),
    );
  }
}
