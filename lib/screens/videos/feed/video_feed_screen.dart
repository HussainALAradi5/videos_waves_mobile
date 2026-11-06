import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../constants/common/messages_constants.dart';
import '../../../constants/common/routes_constants.dart';
import '../../../constants/common/ui_constants.dart';
import '../../../controllers/videos/video/video_feed_controller.dart';
import '../../../widgets/common/feedback/empty_view.dart';
import '../../../widgets/common/layout/constrained_content.dart';
import '../../../widgets/common/lists/paged_list_view.dart';
import '../../../widgets/videos/video/video_card.dart';

class VideoFeedScreen extends StatelessWidget {
  const VideoFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final feed = context.read<VideoFeedController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppMessages.feedTitle),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(Spacing.xl * 2),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(Spacing.md, 0, Spacing.md, Spacing.sm),
            child: TextField(
              onChanged: feed.setSearch,
              textInputAction: TextInputAction.search,
              decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: AppMessages.searchHint),
            ),
          ),
        ),
      ),
      body: ConstrainedContent(
        child: PagedListView(
          controller: feed,
          empty: const EmptyView(title: AppMessages.noVideos, message: AppMessages.noVideosHint),
          itemBuilder: (context, video) => VideoCard(
            video: video,
            onTap: () => context.push(AppRoutes.video(video.id)),
          ),
        ),
      ),
    );
  }
}
