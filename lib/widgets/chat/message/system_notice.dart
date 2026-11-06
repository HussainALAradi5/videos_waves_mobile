import 'package:flutter/material.dart';

import '../../../constants/chat/chat_messages_constants.dart';
import '../../../models/chat/message/message.dart';

/// Centered grey line for group events ("ana added ben").
class SystemNotice extends StatelessWidget {
  const SystemNotice({super.key, required this.message});

  final Message message;

  @override
  Widget build(BuildContext context) {
    final text = ChatMessages.system(message.systemAction, message.sender.userName, message.systemTargetName, message.body);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Center(child: Text(text, style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center)),
    );
  }
}
