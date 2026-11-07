import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:videos_waves_mobile/enums/common/toast_type.dart';
import 'package:videos_waves_mobile/globals/app_toasts.dart';
import 'package:videos_waves_mobile/widgets/common/feedback/toast_host.dart';

void main() {
  testWidgets('a tap on a toast reaches the toast, not the screen underneath', (tester) async {
    var screenTaps = 0;
    var undone = false;
    await tester.pumpWidget(MaterialApp(
      builder: (context, child) => ToastHost(child: child!),
      home: Scaffold(
        appBar: AppBar(actions: [IconButton(icon: const Icon(Icons.more_horiz), onPressed: () => screenTaps++)]),
        body: const SizedBox.expand(),
      ),
    ));
    appToasts.show(ToastType.info, 'Message unsent', actionLabel: 'Undo', onAction: () => undone = true, duration: const Duration(seconds: 5));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Undo'), findsOneWidget);
    await tester.tap(find.text('Undo'));
    await tester.pump(const Duration(milliseconds: 400));
    expect(undone, isTrue);
    expect(screenTaps, 0);
    await tester.pumpAndSettle(const Duration(seconds: 6));
  });
}
