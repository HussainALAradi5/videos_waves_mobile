import 'package:flutter/foundation.dart';

import '../../../dtos/media/media/picked_file_dto.dart';
import '../../../enums/media/media/media_kind.dart';
import '../../../enums/media/upload/upload_status.dart';
import '../../../models/media/upload/upload_item.dart';
import '../../../services/media/media/media_upload_service.dart';
import '../../../utilities/errors/api_exception.dart';

/// Several files uploading side by side to the CDN, each with its own progress, remove, and retry.
class UploadQueueController extends ChangeNotifier {
  UploadQueueController(this._uploads, this.kind, {required this.maxFiles});

  final MediaUploadService _uploads;
  final MediaKind kind;
  final int maxFiles;
  final List<UploadItem> _items = [];
  int _nextId = 0;

  List<UploadItem> get items => List.unmodifiable(_items);
  bool get isEmpty => _items.isEmpty;
  bool get isFull => _items.length >= maxFiles;
  bool get isBusy => _items.any((item) => item.status == UploadStatus.uploading);
  bool get isReady => _items.isNotEmpty && _items.every((item) => item.isDone);
  List<String> get mediaIds => [for (final item in _items) if (item.media != null) item.media!.id];

  /// Adds files up to the limit and starts uploading them; returns how many were skipped.
  int add(List<PickedFileDto> files) {
    final room = maxFiles - _items.length;
    final accepted = files.take(room.clamp(0, files.length)).toList();
    for (final file in accepted) {
      final item = UploadItem(_nextId++, file);
      _items.add(item);
      _start(item);
    }
    notifyListeners();
    return files.length - accepted.length;
  }

  void remove(UploadItem item) {
    _items.remove(item);
    notifyListeners();
  }

  void retry(UploadItem item) => _start(item);

  void clear() {
    _items.clear();
    notifyListeners();
  }

  Future<void> _start(UploadItem item) async {
    item
      ..status = UploadStatus.uploading
      ..progress = 0
      ..error = null;
    notifyListeners();
    try {
      item.media = await _uploads.upload(item.file, kind, onProgress: (value) {
        item.progress = value;
        notifyListeners();
      });
      item.status = UploadStatus.done;
    } catch (error) {
      item
        ..status = UploadStatus.failed
        ..error = errorMessageOf(error);
    }
    if (_items.contains(item)) notifyListeners();
  }
}
