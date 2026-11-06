part of 'thread_controller.dart';

/// Sending and the long-press message actions; edits arrive back through [ThreadController.replace].
extension ThreadMessageActions on ThreadController {
  Future<void> send({String? body, List<String>? attachmentIds, String? voiceNoteId}) async {
    final JsonMap payload = {
      if (body != null && body.trim().isNotEmpty) 'body': body.trim(),
      if (attachmentIds != null && attachmentIds.isNotEmpty) 'attachmentIds': attachmentIds,
      'voiceNoteId': ?voiceNoteId,
      if (replyTo != null) 'replyToId': replyTo!.id,
    };
    setTyping(false);
    upsert(await _messages.send(conversationId, payload));
    setReplyTo(null);
  }

  Future<void> edit(Message message, String body) async => replace(await _messages.edit(conversationId, message.id, body.trim()));

  Future<void> unsend(Message message) async {
    await _messages.remove(conversationId, message.id, DeleteScope.everyone);
    replace(message.copyWith(isUnsent: true));
  }

  Future<void> deleteForMe(Message message) async {
    await _messages.remove(conversationId, message.id, DeleteScope.me);
    removeMessage(message.id);
  }

  /// Same emoji again removes the reaction.
  Future<void> react(Message message, String emoji) async => replace(message.myReaction == emoji
      ? await _messages.unreact(conversationId, message.id)
      : await _messages.react(conversationId, message.id, emoji));
}
