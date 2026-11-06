import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/videos/comment/comment_list_controller.dart';
import '../../../controllers/videos/video/video_details_controller.dart';
import '../../../controllers/videos/video/video_feed_controller.dart';
import '../../../globals/app_dependencies.dart';
import 'video_details_body.dart';

/// Creates the screen's controllers; the body renders them.
class VideoDetailsScreen extends StatelessWidget {
  const VideoDetailsScreen({super.key, required this.videoId});

  final String videoId;

  @override
  Widget build(BuildContext context) {
    final dependencies = context.read<AppDependencies>();
    final feed = context.read<VideoFeedController>();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => VideoDetailsController(
            dependencies.videoService,
            videoId,
            onVideoChanged: feed.updateVideo,
            onVideoDeleted: feed.removeVideo,
          )..load(),
        ),
        ChangeNotifierProvider(create: (_) => CommentListController(dependencies.commentService, videoId)..loadFirstPage()),
      ],
      child: const VideoDetailsBody(),
    );
  }
}
