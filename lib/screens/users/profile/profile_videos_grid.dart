import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../constants/common/gradients_constants.dart';
import '../../../constants/common/routes_constants.dart';
import '../../../constants/users/social/social_messages_constants.dart';
import '../../../controllers/videos/video/video_feed_controller.dart';
import '../../../globals/app_dependencies.dart';
import '../../../widgets/common/feedback/empty_view.dart';
import '../../../widgets/common/waves/wave_loader.dart';

/// Three-column grid of one person's videos; scrolling near the end loads more.
class ProfileVideosGrid extends StatefulWidget {
  const ProfileVideosGrid({super.key, required this.ownerId});

  final String ownerId;

  @override
  State<ProfileVideosGrid> createState() => _ProfileVideosGridState();
}

class _ProfileVideosGridState extends State<ProfileVideosGrid> {
  late final VideoFeedController _videos = VideoFeedController(context.read<AppDependencies>().videoService, ownerId: widget.ownerId)
    ..loadFirstPage();

  @override
  void dispose() {
    _videos.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _videos,
      builder: (context, _) {
        final items = _videos.items;
        if (_videos.isLoading && items.isEmpty) return const SliverToBoxAdapter(child: Center(child: WaveLoader()));
        if (_videos.isEmpty) return const SliverToBoxAdapter(child: EmptyView(title: SocialMessages.noVideos, icon: Icons.video_library_outlined));
        return SliverGrid.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 2, crossAxisSpacing: 2, childAspectRatio: 9 / 12),
          itemCount: items.length,
          itemBuilder: (context, index) {
            if (index >= items.length - 3) _videos.loadNextPage();
            final video = items[index];
            final thumbnail = video.thumbnailUrl;
            return GestureDetector(
              onTap: () => context.push(AppRoutes.video(video.id)),
              child: Hero(
                tag: 'video-${video.id}',
                child: thumbnail == null
                    ? const DecoratedBox(decoration: BoxDecoration(gradient: AppGradients.brand))
                    : Image.network(thumbnail, fit: BoxFit.cover, errorBuilder: (_, _, _) => const DecoratedBox(decoration: BoxDecoration(gradient: AppGradients.brand))),
              ),
            );
          },
        );
      },
    );
  }
}

