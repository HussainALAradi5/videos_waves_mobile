import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/chat/chat_messages_constants.dart';
import '../../../constants/chat/message/message_limits_constants.dart';
import '../../../constants/common/ui_constants.dart';
import '../../../controllers/chat/composer/voice_recorder_controller.dart';
import '../../../controllers/chat/thread/thread_controller.dart';
import '../../../controllers/media/upload/upload_queue_controller.dart';
import '../../../dtos/media/media/picked_file_dto.dart';
import '../../../enums/media/media/media_kind.dart';
import '../../../globals/app_dependencies.dart';
import '../../../utilities/media/file_pick_utility.dart';
import '../../../utilities/ui/feedback_utility.dart';
import '../../../widgets/chat/composer/attachment_strip.dart';
import '../../../widgets/chat/composer/recording_bar.dart';
import '../../../widgets/chat/composer/reply_preview.dart';
import '../../../widgets/chat/composer/send_button.dart';

/// Text, several attachments uploading in the background, and voice notes.
class ThreadComposer extends StatefulWidget {
  const ThreadComposer({super.key});

  @override
  State<ThreadComposer> createState() => _ThreadComposerState();
}

class _ThreadComposerState extends State<ThreadComposer> {
  final TextEditingController _text = TextEditingController();
  final VoiceRecorderController _voice = VoiceRecorderController();
  late final AppDependencies _dependencies = context.read<AppDependencies>();
  late final UploadQueueController _files = UploadQueueController(_dependencies.mediaUploadService, MediaKind.chatAttachment, maxFiles: MessageLimits.maxAttachments);
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _text.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _text.dispose();
    _voice.dispose();
    _files.dispose();
    super.dispose();
  }

  ThreadController get _thread => context.read<ThreadController>();

  Future<void> _pick() async {
    final files = await pickFiles(FileType.any);
    if (files.isNotEmpty && _files.add(files) > 0 && mounted) showMessage(context, ChatMessages.tooManyFiles);
  }

  Future<void> _send() async {
    if (_isSending || _files.isBusy) return;
    final body = _text.text;
    if (body.trim().isEmpty && _files.isEmpty) return;
    setState(() => _isSending = true);
    final sent = await runWithFeedback(context, () => _thread.send(body: body, attachmentIds: _files.mediaIds));
    if (sent) {
      _text.clear();
      _files.clear();
    }
    if (mounted) setState(() => _isSending = false);
  }

  Future<void> _record() async {
    if (!await _voice.start(onLimit: _sendVoice) && mounted) showMessage(context, ChatMessages.micDenied);
  }

  Future<void> _sendVoice(PickedFileDto file) async {
    setState(() => _isSending = true);
    await runWithFeedback(context, () async {
      final media = await _dependencies.mediaUploadService.upload(file, MediaKind.voiceNote);
      await _thread.send(voiceNoteId: media.id);
    });
    if (mounted) setState(() => _isSending = false);
  }

  Future<void> _stopAndSend() async {
    final file = await _voice.stop();
    if (file != null && mounted) await _sendVoice(file);
  }

  @override
  Widget build(BuildContext context) {
    final replyTo = context.select<ThreadController, String?>((thread) => thread.replyTo?.sender.userName);
    final hasContent = _text.text.trim().isNotEmpty || !_files.isEmpty;
    return ListenableBuilder(
      listenable: Listenable.merge([_voice, _files]),
      builder: (context, _) => Padding(
        padding: const EdgeInsets.fromLTRB(Spacing.sm, 0, Spacing.sm, Spacing.sm),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          if (replyTo != null) ReplyPreview(userName: replyTo, onClose: () => _thread.setReplyTo(null)),
          if (!_files.isEmpty) AttachmentStrip(queue: _files),
          if (_voice.isRecording)
            RecordingBar(elapsed: _voice.elapsed, onCancel: _voice.cancel, onSend: _stopAndSend)
          else
            Row(children: [
              IconButton(tooltip: ChatMessages.attach, icon: const Icon(Icons.add_photo_alternate_outlined), onPressed: _files.isFull ? null : _pick),
              Expanded(
                child: TextField(
                  controller: _text,
                  minLines: 1,
                  maxLines: 5,
                  maxLength: MessageLimits.bodyMax,
                  onChanged: (value) => _thread.setTyping(value.trim().isNotEmpty),
                  decoration: const InputDecoration(hintText: ChatMessages.messageHint, counterText: '', isDense: true),
                ),
              ),
              const SizedBox(width: Spacing.xs),
              SendButton(
                isBusy: _isSending || _files.isBusy,
                icon: hasContent ? Icons.send_rounded : Icons.mic_none,
                tooltip: hasContent ? ChatMessages.start : ChatMessages.record,
                onPressed: hasContent ? _send : _record,
              ),
            ]),
        ]),
      ),
    );
  }
}
