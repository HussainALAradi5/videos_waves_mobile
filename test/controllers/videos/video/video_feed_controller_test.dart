import 'package:flutter_test/flutter_test.dart';
import 'package:videos_waves_mobile/controllers/videos/video/video_feed_controller.dart';

import '../../../helpers/fake_video_service.dart';

void main() {
  group('VideoFeedController (PagedListController)', () {
    test('loads pages in order and stops at the last page', () async {
      final service = FakeVideoService(totalItems: 5, pageSize: 2);
      final feed = VideoFeedController(service);

      await feed.loadFirstPage();
      expect(feed.items, hasLength(2));
      expect(feed.hasMore, isTrue);

      await feed.loadNextPage();
      await feed.loadNextPage();
      expect(feed.items, hasLength(5));
      expect(feed.hasMore, isFalse);

      await feed.loadNextPage();
      expect(service.requestedPages, [1, 2, 3]);
    });

    test('reports an empty list without an error', () async {
      final feed = VideoFeedController(FakeVideoService(totalItems: 0));
      await feed.loadFirstPage();
      expect(feed.isEmpty, isTrue);
      expect(feed.error, isNull);
    });

    test('replaces an updated video in place', () async {
      final feed = VideoFeedController(FakeVideoService());
      await feed.loadFirstPage();
      feed.updateVideo(buildVideo('0', isLiked: true, likesCount: 1));
      expect(feed.items.first.isLiked, isTrue);
      expect(feed.items.first.likesCount, 1);
    });
  });
}
