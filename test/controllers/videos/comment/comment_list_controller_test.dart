import 'package:flutter_test/flutter_test.dart';
import 'package:videos_waves_mobile/controllers/videos/comment/comment_list_controller.dart';

import '../../../helpers/fake_comment_service.dart';

void main() {
  group('CommentListController', () {
    test('delete hides the comment, and Undo puts it back in the same place', () async {
      final list = CommentListController(FakeCommentService(3), 'v1');
      await list.loadFirstPage();
      final middle = list.items[1];

      final index = await list.remove(middle);
      expect(list.items.map((item) => item.id), ['c0', 'c2']);
      expect(list.totalItems, 2);

      await list.restore(middle, index);
      expect(list.items.map((item) => item.id), ['c0', 'c1', 'c2']);
      expect(list.totalItems, 3);
    });

    test('a failed delete brings the comment back', () async {
      final service = FakeCommentService(2)..shouldFailRemove = true;
      final list = CommentListController(service, 'v1');
      await list.loadFirstPage();

      await expectLater(list.remove(list.items.first), throwsException);
      expect(list.items.map((item) => item.id), ['c0', 'c1']);
    });

    test('edit replaces the text and marks it edited', () async {
      final list = CommentListController(FakeCommentService(1), 'v1');
      await list.loadFirstPage();
      await list.edit(list.items.first, '  changed  ');
      expect(list.items.first.content, 'changed');
      expect(list.items.first.isEdited, isTrue);
    });
  });
}
