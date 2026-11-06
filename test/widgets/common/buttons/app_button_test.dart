import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:videos_waves_mobile/widgets/common/buttons/app_button.dart';

void main() {
  testWidgets('shows a spinner and ignores taps until the action finishes', (tester) async {
    final pending = Completer<void>();
    var calls = 0;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: AppButton(
          label: 'Save',
          onPressed: () {
            calls++;
            return pending.future;
          },
        ),
      ),
    ));

    await tester.tap(find.byType(AppButton));
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.tap(find.byType(AppButton));
    await tester.pump();
    expect(calls, 1);

    pending.complete();
    await tester.pumpAndSettle();
    expect(find.text('Save'), findsOneWidget);
  });
}
