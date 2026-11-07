import '../../../enums/users/settings/bubble_style.dart';
import '../../../enums/users/settings/setting_control.dart';
import '../../../widgets/users/settings/bubble_shape_icon.dart';
import '../../../models/common/ui/status_option.dart';
import '../../common/app_colors_constants.dart';
import '../../../models/common/ui/dropdown_option.dart';
import '../../../models/users/settings/setting_row.dart';
import 'settings_messages_constants.dart';

const List<DropdownOption<String>> _bubbleColors = [
  DropdownOption(value: 'wave', label: 'Wave'),
  DropdownOption(value: 'ocean', label: 'Ocean'),
  DropdownOption(value: 'sunset', label: 'Sunset'),
  DropdownOption(value: 'forest', label: 'Forest'),
  DropdownOption(value: 'mono', label: 'Mono'),
  DropdownOption(value: 'neutral', label: 'Neutral'),
];

/// Every preference row by key (the same table as the web app).
const List<SettingSection> settingSections = [
  SettingSection(title: SettingsMessages.appearance, rows: [
    SettingRow(key: 'theme', label: 'Theme', description: 'Light, dark, or follow your device.', control: SettingControl.choice, choices: [
      DropdownOption(value: 'system', label: 'System'),
      DropdownOption(value: 'light', label: 'Light'),
      DropdownOption(value: 'dark', label: 'Dark'),
    ]),
  ]),
  SettingSection(title: SettingsMessages.chats, showsBubblePreview: true, rows: [
    SettingRow(key: 'bubbleStyle', label: 'Bubble shape', description: 'Rounded, square, or minimal outlines.', control: SettingControl.choice, choices: [
      DropdownOption(value: 'rounded', label: 'Rounded', leading: BubbleShapeIcon(shape: BubbleStyle.rounded)),
      DropdownOption(value: 'square', label: 'Square', leading: BubbleShapeIcon(shape: BubbleStyle.square)),
      DropdownOption(value: 'minimal', label: 'Minimal', leading: BubbleShapeIcon(shape: BubbleStyle.minimal)),
    ]),
    SettingRow(key: 'bubbleColor', label: 'My messages', description: 'The colour of the messages you send.', control: SettingControl.swatches, choices: _bubbleColors),
    SettingRow(key: 'othersBubbleColor', label: 'Their messages', description: 'The colour of messages you receive.', control: SettingControl.swatches, choices: _bubbleColors),
    SettingRow(key: 'notifyMessages', label: 'Message pop-ups', description: 'Show a pop-up when a message arrives in a chat you do not have open.', control: SettingControl.toggle),
  ]),
  SettingSection(title: SettingsMessages.status, rows: [
    SettingRow(key: 'presence', label: 'Status', description: 'Appear offline to look away even while you are here.', control: SettingControl.choice, choices: [
      DropdownOption(value: 'online', label: 'Online', badge: StatusOption(label: 'Online', color: AppColors.online)),
      DropdownOption(value: 'away', label: 'Away', badge: StatusOption(label: 'Away', color: AppColors.away)),
      DropdownOption(value: 'busy', label: 'Busy', badge: StatusOption(label: 'Busy', color: AppColors.busy)),
      DropdownOption(value: 'invisible', label: 'Appear offline', badge: StatusOption(label: 'Appear offline', color: AppColors.cancelled)),
    ]),
    SettingRow(key: 'statusText', label: 'Custom status', description: 'A short line people see in your chats.', control: SettingControl.text, maxLength: 60, hint: 'In a meeting until 3'),
  ]),
  SettingSection(title: SettingsMessages.privacy, rows: [
    SettingRow(
      key: 'privateAccount',
      label: 'Private account',
      description: 'Only people you approve see your videos and who you follow. Going public accepts everyone waiting.',
      control: SettingControl.toggle,
    ),
    SettingRow(key: 'showActivityStatus', label: 'Activity status', description: 'Let people you chat with see when you are online.', control: SettingControl.toggle),
    SettingRow(key: 'readReceipts', label: 'Read receipts', description: 'Show "Seen" when you have read a message.', control: SettingControl.toggle),
    SettingRow(key: 'messagePermission', label: 'Who can message you', description: 'Others land in your requests.', control: SettingControl.choice, choices: [
      DropdownOption(value: 'everyone', label: 'Everyone'),
      DropdownOption(value: 'following', label: 'People I follow'),
    ]),
  ]),
  SettingSection(title: SettingsMessages.messages, rows: [
    SettingRow(key: 'messagePreviews', label: 'Message previews', description: 'Show the text of new messages in your inbox.', control: SettingControl.toggle),
    SettingRow(key: 'messageSound', label: 'Message sound', description: 'Play a soft sound for new messages.', control: SettingControl.toggle),
  ]),
  SettingSection(title: SettingsMessages.videos, rows: [
    SettingRow(key: 'autoplayVideos', label: 'Autoplay videos', description: 'Start videos muted when you open them.', control: SettingControl.toggle),
  ]),
];
