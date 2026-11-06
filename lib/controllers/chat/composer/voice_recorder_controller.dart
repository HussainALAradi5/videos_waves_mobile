import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:record/record.dart';

import '../../../constants/chat/message/message_limits_constants.dart';
import '../../../constants/common/timings_constants.dart';
import '../../../dtos/media/media/picked_file_dto.dart';

/// Records one voice note (webm on the web, m4a on devices), up to the five-minute limit.
class VoiceRecorderController extends ChangeNotifier {
  final AudioRecorder _recorder = AudioRecorder();
  Timer? _ticker;
  Duration elapsed = Duration.zero;
  bool isRecording = false;
  void Function(PickedFileDto file)? _onLimit;

  String get _extension => kIsWeb ? 'webm' : 'm4a';
  String get _mimeType => kIsWeb ? 'audio/webm' : 'audio/mp4';

  /// Returns false when microphone access is refused.
  Future<bool> start({void Function(PickedFileDto file)? onLimit}) async {
    if (isRecording || !await _recorder.hasPermission()) return false;
    const encoder = kIsWeb ? AudioEncoder.opus : AudioEncoder.aacLc;
    final path = kIsWeb ? '' : '${Directory.systemTemp.path}/voice_${DateTime.now().millisecondsSinceEpoch}.$_extension';
    await _recorder.start(const RecordConfig(encoder: encoder), path: path);
    _onLimit = onLimit;
    elapsed = Duration.zero;
    isRecording = true;
    _ticker = Timer.periodic(Timings.voiceTick, (_) => _tick());
    notifyListeners();
    return true;
  }

  /// Stops and returns the recording, or null if nothing was captured.
  Future<PickedFileDto?> stop() async {
    if (!isRecording) return null;
    final location = await _finish();
    if (location == null) return null;
    final name = 'voice-note.$_extension';
    if (kIsWeb) {
      final response = await Dio().get<List<int>>(location, options: Options(responseType: ResponseType.bytes));
      final bytes = Uint8List.fromList(response.data ?? const []);
      return PickedFileDto(name: name, mimeType: _mimeType, sizeBytes: bytes.length, bytes: bytes);
    }
    return PickedFileDto(name: name, mimeType: _mimeType, sizeBytes: await File(location).length(), path: location);
  }

  Future<void> cancel() async {
    if (!isRecording) return;
    await _finish();
    await _recorder.cancel();
  }

  Future<String?> _finish() async {
    _ticker?.cancel();
    isRecording = false;
    notifyListeners();
    return _recorder.stop();
  }

  Future<void> _tick() async {
    elapsed += Timings.voiceTick;
    notifyListeners();
    if (elapsed < MessageLimits.voiceMax) return;
    final file = await stop();
    if (file != null) _onLimit?.call(file);
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _recorder.dispose();
    super.dispose();
  }
}
