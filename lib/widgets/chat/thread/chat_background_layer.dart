import 'package:flutter/material.dart';

import '../../../constants/chat/chat_background_constants.dart';
import '../../../enums/chat/conversation/chat_background.dart';

/// Paints your wallpaper for this chat behind the messages.
class ChatBackgroundLayer extends StatelessWidget {
  const ChatBackgroundLayer({super.key, required this.background, required this.child});

  final ChatBackground background;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (background == ChatBackground.dots) return CustomPaint(painter: const _DotsPainter(), child: child);
    final gradient = ChatBackgrounds.gradientOf(background);
    return AnimatedContainer(duration: const Duration(milliseconds: 300), decoration: BoxDecoration(gradient: gradient), child: child);
  }
}

class _DotsPainter extends CustomPainter {
  const _DotsPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = ChatBackgrounds.dot;
    for (var y = ChatBackgrounds.dotSpacing / 2; y < size.height; y += ChatBackgrounds.dotSpacing) {
      for (var x = ChatBackgrounds.dotSpacing / 2; x < size.width; x += ChatBackgrounds.dotSpacing) {
        canvas.drawCircle(Offset(x, y), 1.2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DotsPainter oldDelegate) => false;
}
