import 'package:flutter/material.dart';

import '../../../constants/chat/chat_background_constants.dart';
import '../../../constants/chat/chat_messages_constants.dart';
import '../../../enums/chat/conversation/chat_background.dart';
import '../thread/chat_background_layer.dart';

/// A grid of wallpapers for one chat; returns the one picked (null when dismissed).
Future<ChatBackground?> pickChatBackground(BuildContext context, ChatBackground current) {
  return showModalBottomSheet<ChatBackground>(
    context: context,
    showDragHandle: true,
    builder: (sheet) {
      final scheme = Theme.of(sheet).colorScheme;
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(ChatMessages.background, style: Theme.of(sheet).textTheme.titleMedium),
            Text(ChatMessages.backgroundHint, style: Theme.of(sheet).textTheme.bodySmall),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.75,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                for (final background in ChatBackground.values)
                  InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => Navigator.of(sheet).pop(background),
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: scheme.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: background == current ? scheme.primary : scheme.outlineVariant, width: background == current ? 2.5 : 1),
                      ),
                      child: ChatBackgroundLayer(
                        background: background,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(padding: const EdgeInsets.all(6), child: Text(ChatBackgrounds.labels[background]!, style: Theme.of(sheet).textTheme.labelSmall)),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ]),
        ),
      );
    },
  );
}
