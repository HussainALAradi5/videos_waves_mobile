import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/chat/thread/thread_controller.dart';
import '../../../controllers/users/auth/auth_controller.dart';
import '../../../globals/app_dependencies.dart';
import '../../../widgets/common/feedback/error_view.dart';
import '../../../widgets/common/feedback/loading_view.dart';
import '../../../widgets/common/layout/constrained_content.dart';
import 'request_banner.dart';
import 'thread_app_bar.dart';
import 'thread_composer.dart';
import 'thread_message_list.dart';

/// One conversation: live messages, the request banner, and the composer.
class ThreadScreen extends StatelessWidget {
  const ThreadScreen({super.key, required this.conversationId});

  final String conversationId;

  @override
  Widget build(BuildContext context) {
    final myUserId = context.select<AuthController, String?>((auth) => auth.user?.id);
    if (myUserId == null) return const SizedBox.shrink();
    return ChangeNotifierProvider(
      create: (context) {
        final dependencies = context.read<AppDependencies>();
        return ThreadController(
          conversations: dependencies.conversationService,
          messages: dependencies.messageService,
          socket: dependencies.socketService,
          conversationId: conversationId,
          myUserId: myUserId,
        )..load();
      },
      child: const _ThreadBody(),
    );
  }
}

class _ThreadBody extends StatelessWidget {
  const _ThreadBody();

  @override
  Widget build(BuildContext context) {
    final thread = context.watch<ThreadController>();
    final conversation = thread.conversation;
    Widget body;
    if (thread.isLoading && conversation == null) {
      body = const LoadingView();
    } else if (conversation == null) {
      body = ErrorView(error: thread.error ?? '', onRetry: thread.load);
    } else {
      body = Column(children: [
        if (conversation.isRequest) const RequestBanner(),
        const Expanded(child: ThreadMessageList()),
        if (!conversation.isRequest) const ThreadComposer(),
      ]);
    }
    return Scaffold(appBar: const ThreadAppBar(), body: SafeArea(top: false, child: ConstrainedContent(child: body)));
  }
}
