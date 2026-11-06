import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../constants/chat/chat_messages_constants.dart';
import '../../../constants/common/ui_constants.dart';
import '../../../controllers/chat/thread/thread_controller.dart';
import '../../../enums/common/button_tone.dart';
import '../../../globals/app_dependencies.dart';
import '../../../utilities/ui/feedback_utility.dart';
import '../../../widgets/common/buttons/app_button.dart';

/// Accept or delete a message request.
class RequestBanner extends StatelessWidget {
  const RequestBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final thread = context.read<ThreadController>();
    final conversations = context.read<AppDependencies>().conversationService;
    final router = GoRouter.of(context);
    return Card(
      margin: const EdgeInsets.all(Spacing.sm),
      child: Padding(
        padding: const EdgeInsets.all(Spacing.md),
        child: Column(children: [
          Text(ChatMessages.requestTitle, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: Spacing.xs),
          const Text(ChatMessages.requestBody, textAlign: TextAlign.center),
          const SizedBox(height: Spacing.sm),
          Row(children: [
            Expanded(
              child: AppButton(
                label: ChatMessages.delete,
                tone: ButtonTone.outline,
                onPressed: () async {
                  if (await runWithFeedback(context, () => conversations.hide(thread.conversationId))) router.pop();
                },
              ),
            ),
            const SizedBox(width: Spacing.sm),
            Expanded(child: AppButton(label: ChatMessages.accept, onPressed: () => runWithFeedback(context, thread.accept))),
          ]),
        ]),
      ),
    );
  }
}
