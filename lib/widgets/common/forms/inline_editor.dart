import 'package:flutter/material.dart';

import '../../../constants/common/messages_constants.dart';
import '../../../constants/common/motion_constants.dart';
import '../../../constants/common/spacing_constants.dart';
import '../buttons/app_button.dart';
import '../../../enums/common/button_tone.dart';

/// Edits text in place: grows in, Save keeps a spinner until the request ends, Cancel restores.
class InlineEditor extends StatefulWidget {
  const InlineEditor({super.key, required this.initial, required this.onSave, required this.onCancel, this.maxLength});

  final String initial;
  final Future<void> Function(String value) onSave;
  final VoidCallback onCancel;
  final int? maxLength;

  @override
  State<InlineEditor> createState() => _InlineEditorState();
}

class _InlineEditorState extends State<InlineEditor> {
  late final TextEditingController _text = TextEditingController(text: widget.initial);

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final value = _text.text.trim();
    if (value.isEmpty || value == widget.initial) return widget.onCancel();
    await widget.onSave(value);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: Motion.quick,
      child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        TextField(controller: _text, autofocus: true, minLines: 1, maxLines: 5, maxLength: widget.maxLength),
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          AppButton(label: AppMessages.cancel, tone: ButtonTone.ghost, onPressed: () async => widget.onCancel()),
          const SizedBox(width: Spacing.sm),
          AppButton(label: AppMessages.save, tone: ButtonTone.primary, onPressed: _save),
        ]),
      ]),
    );
  }
}
