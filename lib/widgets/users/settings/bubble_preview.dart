import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/users/settings/settings_controller.dart';
import '../../../models/users/settings/user_settings.dart';
import '../../../utilities/chat/bubble_look_utility.dart';

const String _theirs = 'Hey! Did you see the new wave?';
const String _mine = 'Just watched it. So calm.';

/// A two-message sample that changes as you pick a shape or colour.
class BubblePreview extends StatelessWidget {
  const BubblePreview({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.select<SettingsController, UserSettings>((controller) => controller.settings ?? const UserSettings());
    final scheme = Theme.of(context).colorScheme;
    Widget bubble(bool isMine, String text) {
      final look = bubbleLook(
        scheme: scheme,
        isMine: isMine,
        isUnsent: false,
        style: settings.bubbleStyle,
        myColor: settings.bubbleColor,
        othersColor: settings.othersBubbleColor,
      );
      return Align(
        alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(vertical: 3),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: look.decoration,
          child: Text(text, style: TextStyle(color: look.foreground)),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), border: Border.all(color: scheme.outlineVariant)),
      child: Column(children: [bubble(false, _theirs), bubble(true, _mine)]),
    );
  }
}
