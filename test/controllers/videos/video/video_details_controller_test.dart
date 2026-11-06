import 'package:flutter_test/flutter_test.dart';
import 'package:videos_waves_mobile/controllers/videos/video/video_details_controller.dart';
import 'package:videos_waves_mobile/models/videos/video/video.dart';

import '../../../helpers/fake_video_service.dart';

void main() {
  group('VideoDetailsController', () {
    test('likes a video and reports the change', () async {
      final changes = <Video>[];
      final details = VideoDetailsController(FakeVideoService(), '7', onVideoChanged: changes.add);
      await details.load();

      await details.toggleLike();

      expect(details.video!.isLiked, isTrue);
      expect(details.video!.likesCount, 1);
      expect(changes.last.isLiked, isTrue);
    });

    test('rolls the optimistic like back when the API fails', () async {
      final service = FakeVideoService()..shouldFailLike = true;
      final details = VideoDetailsController(service, '7');
      await details.load();

      await expectLater(details.toggleLike(), throwsException);

      expect(details.video!.isLiked, isFalse);
      expect(details.video!.likesCount, 0);
      expect(details.isLiking, isFalse);
    });
  });
}
