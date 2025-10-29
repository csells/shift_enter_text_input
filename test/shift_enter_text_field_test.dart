import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shift_enter_text_input/shift_enter_text_input.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  Future<void> runWithPlatform(
    TargetPlatform platform,
    Future<void> Function() body,
  ) async {
    final previous = debugDefaultTargetPlatformOverride;
    debugDefaultTargetPlatformOverride = platform;
    try {
      await body();
    } finally {
      debugDefaultTargetPlatformOverride = previous;
    }
  }

  group('ShiftEnterTextField (Material)', () {
    testWidgets('submits on Enter for desktop platforms', (tester) async {
      await runWithPlatform(TargetPlatform.macOS, () async {
        String? submitted;
        final controller = TextEditingController();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ShiftEnterTextField(
                controller: controller,
                maxLines: null,
                onSubmitted: (value) => submitted = value,
              ),
            ),
          ),
        );

        await tester.enterText(find.byType(ShiftEnterTextField), 'Hello');
        await tester.sendKeyEvent(LogicalKeyboardKey.enter);
        await tester.pump();

        expect(submitted, 'Hello');
      });
    });

    testWidgets('inserts newline on Shift+Enter without submitting',
        (tester) async {
      await runWithPlatform(TargetPlatform.macOS, () async {
        String? submitted;
        final controller = TextEditingController();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ShiftEnterTextField(
                controller: controller,
                maxLines: null,
                onSubmitted: (value) => submitted = value,
              ),
            ),
          ),
        );

        final fieldFinder = find.byType(ShiftEnterTextField);
        await tester.enterText(fieldFinder, 'Hello');
        expect(controller.text, 'Hello');

        await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
        await tester.sendKeyEvent(LogicalKeyboardKey.enter);
        await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
        await tester.pump();

        expect(controller.text, 'Hello\n');
        expect(submitted, isNull);
      });
    });

    testWidgets('lets mobile platforms handle newline without submitting',
        (tester) async {
      await runWithPlatform(TargetPlatform.android, () async {
        String? submitted;
        final controller = TextEditingController();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ShiftEnterTextField(
                controller: controller,
                maxLines: null,
                onSubmitted: (value) => submitted = value,
              ),
            ),
          ),
        );

        await tester.enterText(find.byType(ShiftEnterTextField), 'Hello');
        expect(controller.text, 'Hello');

        await tester.sendKeyEvent(LogicalKeyboardKey.enter);
        await tester.pump();

        expect(controller.text, 'Hello');
        expect(submitted, isNull);
      });
    });
  });

  group('ShiftEnterTextFormField (Material)', () {
    testWidgets('propagates submitted value through FormField on desktop',
        (tester) async {
      await runWithPlatform(TargetPlatform.macOS, () async {
        final fieldKey = GlobalKey<FormFieldState<String>>();
        String? submitted;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Form(
                child: ShiftEnterTextFormField(
                  key: fieldKey,
                  onFieldSubmitted: (value) => submitted = value,
                ),
              ),
            ),
          ),
        );

        await tester.enterText(find.byType(ShiftEnterTextField), 'Hello');
        expect(fieldKey.currentState!.value, 'Hello');
        await tester.sendKeyEvent(LogicalKeyboardKey.enter);
        await tester.pump();

        expect(submitted, 'Hello');
        expect(fieldKey.currentState!.value, 'Hello');
      });
    });

    testWidgets('avoids premature form submission on mobile enter key',
        (tester) async {
      await runWithPlatform(TargetPlatform.iOS, () async {
        final fieldKey = GlobalKey<FormFieldState<String>>();
        String? submitted;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Form(
                child: ShiftEnterTextFormField(
                  key: fieldKey,
                  onFieldSubmitted: (value) => submitted = value,
                ),
              ),
            ),
          ),
        );

        await tester.enterText(find.byType(ShiftEnterTextField), 'Hello');
        expect(fieldKey.currentState!.value, 'Hello');
        await tester.sendKeyEvent(LogicalKeyboardKey.enter);
        await tester.pump();

        expect(fieldKey.currentState!.value, 'Hello');
        expect(submitted, isNull);
      });
    });
  });
}
