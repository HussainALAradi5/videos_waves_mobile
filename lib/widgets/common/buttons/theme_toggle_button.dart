import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/common/messages_constants.dart';
import '../../../controllers/users/settings/settings_controller.dart';
import '../../../utilities/ui/feedback_utility.dart';

/// Sun in dark mode, moon in light mode; the icon turns as it switches.
class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    return IconButton(
      tooltip: isDark ? AppMessages.lightMode : AppMessages.darkMode,
      onPressed: () => runWithFeedback(context, () => context.read<SettingsController>().toggleTheme(brightness)),
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) => RotationTransition(turns: Tween(begin: 0.6, end: 1.0).animate(animation), child: FadeTransition(opacity: animation, child: child)),
        child: Icon(isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined, key: ValueKey(isDark)),
      ),
    );
  }
}
