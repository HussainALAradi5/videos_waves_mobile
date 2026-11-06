import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../constants/chat/chat_messages_constants.dart';
import '../../../constants/common/messages_constants.dart';
import '../../../constants/common/limits_constants.dart';
import '../../../dtos/common/pagination/page_request_dto.dart';
import '../../../globals/app_dependencies.dart';
import '../../../models/common/ui/dropdown_option.dart';
import '../../../utilities/ui/feedback_utility.dart';
import '../../../widgets/common/avatars/user_avatar.dart';
import '../../../widgets/common/dropdown/multi_select_sheet.dart';

/// Pick people: one opens a direct chat, several ask for a group name and create a group.
Future<void> startNewChat(BuildContext context) async {
  final dependencies = context.read<AppDependencies>();
  final router = GoRouter.of(context);
  final picked = await MultiSelectSheet.show<String>(
    context,
    MultiSelectSheet<String>(
      title: ChatMessages.pickPeople,
      confirmLabel: ChatMessages.start,
      search: (text) async {
        final page = await dependencies.socialService.search(text, const PageRequestDto(page: 1, pageSize: PageSizes.users));
        return [
          for (final summary in page.items)
            if (!summary.isMe) DropdownOption(value: summary.user.userName, label: summary.user.userName, leading: UserAvatar(user: summary.user, size: 32)),
        ];
      },
    ),
  );
  if (picked == null || picked.isEmpty || !context.mounted) return;
  final names = [for (final option in picked) option.value];
  String? title;
  if (names.length > 1) {
    title = await _askGroupName(context);
    if (title == null || !context.mounted) return;
  }
  await runWithFeedback(context, () async {
    final conversation = names.length == 1
        ? await dependencies.conversationService.startDirect(names.first)
        : await dependencies.conversationService.createGroup(title!, names);
    router.push('/messages/${conversation.id}');
  });
}

Future<String?> _askGroupName(BuildContext context) {
  final text = TextEditingController();
  return showDialog<String>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text(ChatMessages.createGroup),
      content: TextField(controller: text, autofocus: true, maxLength: 60, decoration: const InputDecoration(labelText: ChatMessages.groupName)),
      actions: [
        TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: const Text(AppMessages.cancel)),
        FilledButton(
          onPressed: () => text.text.trim().isEmpty ? null : Navigator.of(dialogContext).pop(text.text.trim()),
          child: const Text(ChatMessages.createGroup),
        ),
      ],
    ),
  ).whenComplete(text.dispose);
}
