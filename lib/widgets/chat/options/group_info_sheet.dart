import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../constants/chat/chat_messages_constants.dart';
import '../../../constants/common/gradients_constants.dart';
import '../../../constants/common/routes_constants.dart';
import '../../../controllers/users/auth/auth_controller.dart';
import '../../../enums/chat/conversation/member_role.dart';
import '../../../models/chat/conversation/conversation.dart';
import '../../../models/users/user/public_user.dart';
import '../../common/avatars/user_avatar.dart';
import '../conversation/admin_badge.dart';

/// Tapping a group's name: its picture and name, then every member (you first, admins next) with Admin badges.
Future<void> showGroupInfo(BuildContext context, Conversation conversation) {
  FocusManager.instance.primaryFocus?.unfocus();
  final me = context.read<AuthController>().user;
  final members = [...conversation.members]..sort((left, right) => (right.role == MemberRole.admin ? 1 : 0) - (left.role == MemberRole.admin ? 1 : 0));
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (sheet) {
      void open(String userName) {
        Navigator.of(sheet).pop();
        context.push(AppRoutes.user(userName));
      }

      Widget row(PublicUser user, {required bool isAdmin, String? subtitle}) => ListTile(
            leading: UserAvatar(user: user, size: 44),
            title: Row(children: [
              Flexible(child: Text(user.userName, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w600))),
              if (isAdmin) ...[const SizedBox(width: 6), const AdminBadge()],
            ]),
            subtitle: subtitle == null ? null : Text(subtitle),
            onTap: () => open(user.userName),
          );

      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        maxChildSize: 0.92,
        builder: (_, scroll) => ListView(controller: scroll, children: [
          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(shape: BoxShape.circle, gradient: AppGradients.brand),
              child: const Icon(Icons.groups, color: Colors.white, size: 40),
            ),
          ),
          const SizedBox(height: 10),
          Center(child: Text(conversation.displayTitle, style: Theme.of(sheet).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700))),
          Center(child: Text(ChatMessages.members(conversation.membersCount), style: Theme.of(sheet).textTheme.bodySmall)),
          const SizedBox(height: 12),
          const Divider(),
          if (me != null)
            row(
              PublicUser(id: me.id, userName: me.userName, avatarUrl: me.avatarUrl, gender: me.gender),
              isAdmin: conversation.myRole == MemberRole.admin,
              subtitle: ChatMessages.you,
            ),
          for (final member in members) row(member.user, isAdmin: member.role == MemberRole.admin),
        ]),
      );
    },
  );
}
