import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/chat/chat_messages_constants.dart';
import '../../../constants/common/app_colors_constants.dart';
import '../../../controllers/users/settings/settings_controller.dart';
import '../../../enums/users/settings/presence_mode.dart';
import '../../../utilities/ui/feedback_utility.dart';

const Map<PresenceMode, ({String label, Color color})> _modes = {
  PresenceMode.online: (label: 'Online', color: AppColors.online),
  PresenceMode.away: (label: 'Away', color: AppColors.away),
  PresenceMode.busy: (label: 'Busy', color: AppColors.busy),
  PresenceMode.invisible: (label: 'Appear offline', color: AppColors.cancelled),
};

/// Your status as a coloured dot; tap to pick Online, Away, Busy, or Appear offline (the custom line is in Settings).
class StatusMenuButton extends StatelessWidget {
  const StatusMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    final mode = context.select<SettingsController, PresenceMode>((settings) => settings.settings?.presence ?? PresenceMode.online);
    Widget dot(Color color) => Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle));
    return PopupMenuButton<PresenceMode>(
      tooltip: ChatMessages.statusPicker,
      icon: dot(_modes[mode]!.color),
      onSelected: (next) => runWithFeedback(context, () => context.read<SettingsController>().change({'presence': next.wire})),
      itemBuilder: (_) => [
        for (final entry in _modes.entries)
          CheckedPopupMenuItem(value: entry.key, checked: entry.key == mode, child: Row(children: [dot(entry.value.color), const SizedBox(width: 10), Text(entry.value.label)])),
      ],
    );
  }
}
