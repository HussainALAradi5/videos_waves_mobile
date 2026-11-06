import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../constants/common/messages_constants.dart';
import '../../../constants/common/routes_constants.dart';
import '../../../constants/common/ui_constants.dart';
import '../../../constants/videos/video/video_messages_constants.dart';
import '../../../controllers/users/auth/auth_controller.dart';
import '../../../controllers/videos/video/video_feed_controller.dart';
import '../../../enums/videos/video/feed_scope.dart';
import '../../../models/common/ui/dropdown_option.dart';
import '../../../widgets/common/brand/brand_title.dart';
import '../../../widgets/common/feedback/empty_view.dart';
import '../../../widgets/common/buttons/theme_toggle_button.dart';
import '../../../widgets/common/layout/constrained_content.dart';
import '../../../widgets/common/lists/paged_list_view.dart';
import '../../../widgets/common/motion/fade_slide_in.dart';
import '../../../widgets/common/tabs/segmented_tabs.dart';
import '../../../widgets/notifications/notification_bell.dart';
import '../../../widgets/videos/video/video_card.dart';

List<DropdownOption<FeedScope>> _scopesFor({required bool isSignedIn}) => [
      const DropdownOption(value: FeedScope.all, label: VideoMessages.forYou, leading: Icon(Icons.auto_awesome)),
      if (isSignedIn) const DropdownOption(value: FeedScope.following, label: VideoMessages.following, leading: Icon(Icons.group_outlined)),
      const DropdownOption(value: FeedScope.discover, label: VideoMessages.discover, leading: Icon(Icons.explore_outlined)),
    ];

/// Home: For you, Following, and Discover, with a title search, the theme switch, and the bell.
class VideoFeedScreen extends StatelessWidget {
  const VideoFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final feed = context.watch<VideoFeedController>();
    final isSignedIn = context.select<AuthController, bool>((auth) => auth.isAuthenticated);
    return Scaffold(
      appBar: AppBar(
        title: const BrandTitle(),
        actions: [const ThemeToggleButton(), if (isSignedIn) const NotificationBell()],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(124),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(Spacing.md, 0, Spacing.md, Spacing.sm),
            child: Column(children: [
              TextField(
                onChanged: feed.setSearch,
                textInputAction: TextInputAction.search,
                decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: AppMessages.searchHint, isDense: true),
              ),
              const SizedBox(height: Spacing.sm),
              SegmentedTabs(options: _scopesFor(isSignedIn: isSignedIn), value: feed.scope, onChanged: feed.setScope),
            ]),
          ),
        ),
      ),
      body: ConstrainedContent(
        child: PagedListView(
          controller: feed,
          empty: EmptyView(
            title: AppMessages.noVideos,
            message: feed.scope == FeedScope.following ? VideoMessages.noFollowingVideos : AppMessages.noVideosHint,
          ),
          itemBuilder: (context, video) => FadeSlideIn(
            child: VideoCard(video: video, onTap: () => context.push(AppRoutes.video(video.id))),
          ),
        ),
      ),
    );
  }
}
