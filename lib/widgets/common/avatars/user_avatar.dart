import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants/common/app_colors_constants.dart';
import '../../../constants/common/gradients_constants.dart';
import '../../../constants/users/user/avatar_constants.dart';
import '../../../enums/chat/realtime/presence_state.dart';
import '../../../models/users/user/public_user.dart';

/// A profile photo, falling back to the standard male, female, or neutral avatar.
class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key, required this.user, this.size = 36, this.hasRing = false, this.isOnline, this.presence});

  final PublicUser user;
  final double size;
  final bool hasRing;

  /// Shows a green dot when true; null hides it (unknown or private).
  final bool? isOnline;

  /// Colours the dot (green online, amber away, red busy); offline or null hides it.
  final PresenceState? presence;

  Color? get _dotColor => switch (presence) {
        PresenceState.online => AppColors.online,
        PresenceState.away => AppColors.away,
        PresenceState.busy => AppColors.busy,
        PresenceState.offline => null,
        null => isOnline == true ? AppColors.online : null,
      };

  @override
  Widget build(BuildContext context) {
    final url = user.avatarUrl;
    final picture = ClipOval(
      child: url == null
          ? SvgPicture.asset(DefaultAvatars.forGender(user.gender), width: size, height: size)
          : Image.network(url, width: size, height: size, fit: BoxFit.cover,
              errorBuilder: (_, _, _) => SvgPicture.asset(DefaultAvatars.forGender(user.gender), width: size, height: size)),
    );
    return Semantics(
      label: user.userName,
      child: Stack(clipBehavior: Clip.none, children: [
        Container(
          padding: EdgeInsets.all(hasRing ? 2.5 : 0),
          decoration: BoxDecoration(shape: BoxShape.circle, gradient: hasRing ? AppGradients.brand : null),
          child: picture,
        ),
        if (_dotColor != null)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: size * 0.28,
              height: size * 0.28,
              decoration: BoxDecoration(
                color: _dotColor,
                shape: BoxShape.circle,
                border: Border.all(color: Theme.of(context).colorScheme.surface, width: 2),
              ),
            ),
          ),
      ]),
    );
  }
}
