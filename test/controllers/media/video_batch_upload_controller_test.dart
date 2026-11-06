import 'package:flutter_test/flutter_test.dart';
import 'package:videos_waves_mobile/controllers/videos/video/video_batch_upload_controller.dart';
import 'package:videos_waves_mobile/dtos/media/media/picked_file_dto.dart';
import 'package:videos_waves_mobile/enums/media/media/media_kind.dart';
import 'package:videos_waves_mobile/models/media/media/media.dart';
import 'package:videos_waves_mobile/services/api/api_client.dart';
import 'package:videos_waves_mobile/services/media/media/media_upload_service.dart';
import 'package:videos_waves_mobile/services/storage/token_storage.dart';

import '../../helpers/fake_video_service.dart';

/// Uploads succeed at once with a media id taken from the file name.
class FakeUploads extends MediaUploadService {
  FakeUploads() : super(ApiClient(tokenStorage: TokenStorage(), onSessionExpired: () {}));

  @override
  Future<Media> upload(PickedFileDto file, MediaKind kind, {void Function(double progress)? onProgress}) async {
    onProgress?.call(1);
    return Media(
      id: 'm-${file.name}',
      code: 'MED',
      url: 'https://cdn.example.com/${file.name}',
      mimeType: file.mimeType,
      sizeBytes: file.sizeBytes,
      originalName: file.name,
      createdAt: DateTime(2026),
    );
  }
}

PickedFileDto video(String name) => PickedFileDto(name: name, mimeType: 'video/mp4', sizeBytes: 10);

void main() {
  test('uploads each video, titles it from the file name, and publishes in order', () async {
    final videos = FakeVideoService();
    final batch = VideoBatchUploadController(FakeUploads(), videos);

    batch.add([video('my_first-wave.mp4'), video('beach.mp4')]);
    await pumpEventQueue();

    expect(batch.isReady, isTrue);
    expect(batch.titleOf(batch.items.first), 'my first wave');
    batch.setTitle(batch.items.last, 'Beach day');

    expect(await batch.publish(), 2);
    expect(videos.createdTitles, ['my first wave', 'Beach day']);
    expect(batch.isEmpty, isTrue);
  });

  test('skips files over the limit of ten', () {
    final batch = VideoBatchUploadController(FakeUploads(), FakeVideoService());
    final skipped = batch.add([for (var index = 0; index < 12; index++) video('v$index.mp4')]);
    expect(skipped, 2);
    expect(batch.items, hasLength(10));
  });
}
