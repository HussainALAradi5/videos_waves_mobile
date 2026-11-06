import '../../../enums/users/settings/setting_control.dart';
import '../../../models/common/ui/dropdown_option.dart';
import '../../../models/users/settings/setting_row.dart';
import 'settings_messages_constants.dart';

/// Every preference row by key (the same table as the web app).
const List<SettingSection> settingSections = [
  SettingSection(title: SettingsMessages.appearance, rows: [
    SettingRow(key: 'theme', label: 'Theme', description: 'Light, dark, or follow your device.', control: SettingControl.choice, choices: [
      DropdownOption(value: 'system', label: 'System'),
      DropdownOption(value: 'light', label: 'Light'),
      DropdownOption(value: 'dark', label: 'Dark'),
    ]),
    SettingRow(key: 'bubbleColor', label: 'Chat bubbles', description: 'The colour of your own messages.', control: SettingControl.choice, choices: [
      DropdownOption(value: 'wave', label: 'Wave'),
      DropdownOption(value: 'ocean', label: 'Ocean'),
      DropdownOption(value: 'sunset', label: 'Sunset'),
      DropdownOption(value: 'forest', label: 'Forest'),
      DropdownOption(value: 'mono', label: 'Mono'),
    ]),
  ]),
  SettingSection(title: SettingsMessages.privacy, rows: [
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

