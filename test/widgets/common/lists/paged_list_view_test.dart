import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:videos_waves_mobile/controllers/videos/video/video_feed_controller.dart';
import 'package:videos_waves_mobile/widgets/common/feedback/empty_view.dart';
import 'package:videos_waves_mobile/widgets/common/lists/paged_list_view.dart';

import '../../../helpers/fake_video_service.dart';

Widget _host(VideoFeedController feed) => MaterialApp(
      home: Scaffold(
        body: PagedListView(
          controller: feed,
          empty: const EmptyView(title: 'Nothing here'),
          itemBuilder: (context, video) => ListTile(title: Text(video.title)),
        ),
      ),
    );

void main() {
  testWidgets('renders items from the controller', (tester) async {
    final feed = VideoFeedController(FakeVideoService(totalItems: 2, pageSize: 2));
    await feed.loadFirstPage();
    await tester.pumpWidget(_host(feed));

    expect(find.text('Video 0'), findsOneWidget);
    expect(find.text('Video 1'), findsOneWidget);
  });

  testWidgets('shows the empty view when there are no items', (tester) async {
    final feed = VideoFeedController(FakeVideoService(totalItems: 0));
    await feed.loadFirstPage();
    await tester.pumpWidget(_host(feed));

    expect(find.text('Nothing here'), findsOneWidget);
  });
}
