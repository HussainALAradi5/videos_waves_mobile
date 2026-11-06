import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../constants/common/messages_constants.dart';
import '../../../constants/common/routes_constants.dart';

/// Sign-in and sign-up header: back when there is somewhere to go back to, otherwise home.
class AuthAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AuthAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final canPop = context.canPop();
    return AppBar(
      leading: IconButton(
        tooltip: canPop ? MaterialLocalizations.of(context).backButtonTooltip : AppMessages.backHome,
        icon: Icon(canPop ? Icons.arrow_back : Icons.home_outlined),
        onPressed: () => canPop ? context.pop() : context.go(AppRoutes.feed),
      ),
    );
  }
}
