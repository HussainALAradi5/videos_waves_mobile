import 'package:flutter/material.dart';

import '../../../constants/users/social/social_messages_constants.dart';
import '../../../controllers/users/social/user_list_controller.dart';
import '../../../utilities/ui/feedback_utility.dart';
import '../../common/feedback/empty_view.dart';
import '../../common/lists/paged_list_view.dart';
import '../../common/motion/fade_slide_in.dart';
import 'user_tile.dart';

/// A paged list of people from any UserListController.
class UserListView extends StatelessWidget {
  const UserListView({super.key, required this.controller, this.empty = const EmptyView(title: SocialMessages.noUsers, icon: Icons.people_outline)});

  final UserListController controller;
  final Widget empty;

  @override
  Widget build(BuildContext context) {
    return PagedListView(
      controller: controller,
      empty: empty,
      itemBuilder: (context, summary) => FadeSlideIn(
        child: UserTile(summary: summary, onToggleFollow: () => runWithFeedback(context, () => controller.toggleFollow(summary))),
      ),
    );
  }
}
