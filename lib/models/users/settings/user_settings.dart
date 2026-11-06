import '../../../enums/users/settings/bubble_color.dart';
import '../../../enums/users/settings/bubble_style.dart';
import '../../../enums/users/settings/presence_mode.dart';
import '../../../enums/users/settings/message_permission.dart';
import '../../../enums/users/settings/theme_preference.dart';
import '../../common/json_map.dart';

/// Settings by key (same keys and defaults as the server).
class UserSettings {
  const UserSettings({
    this.theme = ThemePreference.system,
    this.autoplayVideos = true,
    this.showActivityStatus = true,
    this.readReceipts = true,
    this.messagePermission = MessagePermission.everyone,
    this.messagePreviews = true,
    this.messageSound = true,
    this.bubbleColor = BubbleColor.wave,
    this.othersBubbleColor = BubbleColor.neutral,
    this.bubbleStyle = BubbleStyle.rounded,
    this.notifyMessages = true,
    this.presence = PresenceMode.online,
    this.statusText = '',
    this.privateAccount = false,
  });

  factory UserSettings.fromJson(JsonMap json) => UserSettings(
        theme: ThemePreference.fromWire(json['theme'] as String?),
        autoplayVideos: json['autoplayVideos'] as bool? ?? true,
        showActivityStatus: json['showActivityStatus'] as bool? ?? true,
        readReceipts: json['readReceipts'] as bool? ?? true,
        messagePermission: MessagePermission.fromWire(json['messagePermission'] as String?),
        messagePreviews: json['messagePreviews'] as bool? ?? true,
        messageSound: json['messageSound'] as bool? ?? true,
        bubbleColor: BubbleColor.fromWire(json['bubbleColor'] as String?),
        othersBubbleColor: BubbleColor.fromWire(json['othersBubbleColor'] as String? ?? BubbleColor.neutral.wire),
        bubbleStyle: BubbleStyle.fromWire(json['bubbleStyle'] as String?),
        notifyMessages: json['notifyMessages'] as bool? ?? true,
        presence: PresenceMode.fromWire(json['presence'] as String?),
        statusText: json['statusText'] as String? ?? '',
        privateAccount: json['privateAccount'] as bool? ?? false,
      );

  final ThemePreference theme;
  final bool autoplayVideos;
  final bool showActivityStatus;
  final bool readReceipts;
  final MessagePermission messagePermission;
  final bool messagePreviews;
  final bool messageSound;
  final BubbleColor bubbleColor;
  final BubbleColor othersBubbleColor;
  final BubbleStyle bubbleStyle;

  /// A toast when a message arrives in a chat that is not open.
  final bool notifyMessages;
  final PresenceMode presence;
  final String statusText;

  /// Only approved followers see your videos and follow lists.
  final bool privateAccount;

  /// Applies one changed key (as sent to the server) for an optimistic update.
  UserSettings apply(JsonMap changes) => UserSettings.fromJson({...toJson(), ...changes});

  JsonMap toJson() => {
        'theme': theme.wire,
        'autoplayVideos': autoplayVideos,
        'showActivityStatus': showActivityStatus,
        'readReceipts': readReceipts,
        'messagePermission': messagePermission.wire,
        'messagePreviews': messagePreviews,
        'messageSound': messageSound,
        'bubbleColor': bubbleColor.wire,
        'othersBubbleColor': othersBubbleColor.wire,
        'bubbleStyle': bubbleStyle.wire,
        'notifyMessages': notifyMessages,
        'presence': presence.wire,
        'statusText': statusText,
        'privateAccount': privateAccount,
      };
}
