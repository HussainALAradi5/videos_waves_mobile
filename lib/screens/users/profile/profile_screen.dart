import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../constants/common/routes_constants.dart';
import '../../../constants/users/settings/settings_messages_constants.dart';
import '../../../constants/users/social/social_messages_constants.dart';
import '../../../controllers/users/auth/auth_controller.dart';
import '../../../controllers/users/profile/profile_controller.dart';
import '../../../globals/app_dependencies.dart';
import '../../../utilities/errors/api_exception.dart';
import '../../../widgets/common/feedback/empty_view.dart';
import '../../../widgets/common/feedback/error_view.dart';
import '../../../widgets/common/feedback/loading_view.dart';
import '../../../widgets/common/layout/constrained_content.dart';
import 'profile_header.dart';
import 'profile_videos_grid.dart';

/// Someone's profile, or yours when [userName] is null (the Profile tab).
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, this.userName});

  final String? userName;

  @override
  Widget build(BuildContext context) {
    final me = context.select<AuthController, String?>((auth) => auth.user?.userName);
    final target = userName ?? me;
    if (target == null) return const SizedBox.shrink();
    return ChangeNotifierProvider(
      key: ValueKey(target),
      create: (context) => ProfileController(context.read<AppDependencies>().socialService, target)..load(),
      child: _ProfileBody(isMe: target == me),
    );
  }
}

class _ProfileBody extends StatelessWidget {
  const _ProfileBody({required this.isMe});

  final bool isMe;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ProfileController>();
    final profile = controller.profile;
    Widget body;
    if (controller.isLoading && profile == null) {
      body = const LoadingView();
    } else if (controller.error is ApiException && (controller.error! as ApiException).isNotFound) {
      body = const EmptyView(title: SocialMessages.userNotFound, icon: Icons.person_off_outlined);
    } else if (profile == null) {
      body = ErrorView(error: controller.error ?? SocialMessages.userNotFound, onRetry: controller.load);
    } else {
      body = RefreshIndicator(
        onRefresh: controller.load,
        child: CustomScrollView(slivers: [
          SliverToBoxAdapter(child: ProfileHeader(profile: profile)),
          if (!profile.isBlocked) ProfileVideosGrid(key: ValueKey(profile.user.id), ownerId: profile.user.id),
        ]),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.userName, style: const TextStyle(fontWeight: FontWeight.w700)),
        actions: [
          if (isMe) IconButton(tooltip: SettingsMessages.title, icon: const Icon(Icons.settings_outlined), onPressed: () => context.push(AppRoutes.settings)),
        ],
      ),
      body: ConstrainedContent(child: body),
    );
  }
}
