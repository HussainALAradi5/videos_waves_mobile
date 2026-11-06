import 'package:flutter/material.dart';

import '../../../constants/chat/chat_messages_constants.dart';

/// The small "Admin" pill beside a group admin's name, in group info and on their messages.
class AdminBadge extends StatelessWidget {
  const AdminBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: primary.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(20)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.verified_user, size: 11, color: primary),
        const SizedBox(width: 3),
        Text(ChatMessages.admin, style: TextStyle(color: primary, fontSize: 10.5, fontWeight: FontWeight.w700)),
      ]),
    );
  }
}
