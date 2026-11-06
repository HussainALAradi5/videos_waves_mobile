import 'package:flutter/material.dart';

import '../../enums/chat/conversation/chat_background.dart';

/// See-through layers, so the same wallpaper suits light and dark (same set as the web app).
class ChatBackgrounds {
  const ChatBackgrounds._();

  static const Map<ChatBackground, String> labels = {
    ChatBackground.none: 'Default',
    ChatBackground.waves: 'Waves',
    ChatBackground.ocean: 'Ocean',
    ChatBackground.mint: 'Mint',
    ChatBackground.sand: 'Sand',
    ChatBackground.blush: 'Blush',
    ChatBackground.night: 'Night',
    ChatBackground.dots: 'Dots',
  };

  static Gradient? gradientOf(ChatBackground background) => switch (background) {
        ChatBackground.none || ChatBackground.dots => null,
        ChatBackground.waves => const RadialGradient(center: Alignment.topLeft, radius: 1.4, colors: [Color(0x293A7BB5), Color(0x00000000)]),
        ChatBackground.ocean => const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0x140A9DF0), Color(0x330F64A8)]),
        ChatBackground.mint => const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0x1A1FB88A), Color(0x2E0F7A5C)]),
        ChatBackground.sand => const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0x33F5C88C), Color(0x29D6A064)]),
        ChatBackground.blush => const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0x38FFAFC3), Color(0x1AFF8CAA)]),
        ChatBackground.night => const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0x1A0D1F30), Color(0x570D1F30)]),
      };

  static const Color dot = Color(0x475B8FC4);
  static const double dotSpacing = 18;
}
