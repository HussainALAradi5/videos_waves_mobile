import 'package:flutter_test/flutter_test.dart';
import 'package:videos_waves_mobile/enums/users/admin_request/admin_request_status.dart';
import 'package:videos_waves_mobile/models/users/admin_request/admin_request.dart';
import 'package:videos_waves_mobile/models/videos/video/video.dart';

void main() {
  test('maps the server video DTO once, including the owner', () {
    final video = Video.fromJson({
      'id': 'v1',
      'code': 'VID-ABCDEFGH',
      'title': 'Sunrise',
      'description': 'Calm waves',
      'videoUrl': 'http://localhost:5000/media/videos/v1.mp4',
      'mimeType': 'video/mp4',
      'owner': {'id': 'u1', 'userName': 'surfer', 'image': null},
      'likesCount': 3,
      'commentsCount': 1,
      'viewsCount': 10,
      'isLiked': true,
      'createdAt': '2026-11-06T10:00:00.000Z',
      'updatedAt': '2026-11-06T10:00:00.000Z',
    });

    expect(video.owner.userName, 'surfer');
    expect(video.isLiked, isTrue);
    expect(video.copyWith(likesCount: 4).likesCount, 4);
    expect(video.copyWith(likesCount: 4).title, 'Sunrise');
  });

  test('unknown admin request statuses fall back to pending', () {
    final request = AdminRequest.fromJson({
      'id': 'r1',
      'code': 'ADR-ABCDEFGH',
      'reason': 'Help moderate',
      'status': 'cancelled',
      'requester': {'id': 'u1', 'userName': 'surfer'},
      'createdAt': '2026-11-06T10:00:00.000Z',
    });
    expect(request.status, AdminRequestStatus.cancelled);
    expect(AdminRequestStatus.fromWire('unexpected'), AdminRequestStatus.pending);
  });
}
