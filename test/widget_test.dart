import 'dart:ui' show Size;

import 'package:calc_pro/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('calculator opens and evaluates a basic expression', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const CalcProApp());

    expect(find.text('CalcPro'), findsOneWidget);

    await tester.tap(find.text('7'));
    await tester.tap(find.text('+'));
    await tester.tap(find.text('8'));
    await tester.tap(find.text('='));
    await tester.pump();

    expect(find.text('15'), findsOneWidget);
  });
}
