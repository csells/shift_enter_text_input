import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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

  group('CupertinoShiftEnterTextField', () {
    testWidgets('submits on Enter for desktop platforms', (tester) async {
      await runWithPlatform(TargetPlatform.macOS, () async {
        String? submitted;
        final controller = TextEditingController();

        await tester.pumpWidget(
          CupertinoApp(
            home: CupertinoPageScaffold(
              child: CupertinoShiftEnterTextField(
                controller: controller,
                onSubmitted: (value) => submitted = value,
              ),
            ),
          ),
        );

        final fieldFinder = find.byType(CupertinoShiftEnterTextField);
        await tester.enterText(fieldFinder, 'Hello');
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
          CupertinoApp(
            home: CupertinoPageScaffold(
              child: CupertinoShiftEnterTextField(
                controller: controller,
                onSubmitted: (value) => submitted = value,
              ),
            ),
          ),
        );

        final fieldFinder = find.byType(CupertinoShiftEnterTextField);
        await tester.enterText(fieldFinder, 'Hello');
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
      await runWithPlatform(TargetPlatform.iOS, () async {
        String? submitted;
        final controller = TextEditingController();

        await tester.pumpWidget(
          CupertinoApp(
            home: CupertinoPageScaffold(
              child: CupertinoShiftEnterTextField(
                controller: controller,
                onSubmitted: (value) => submitted = value,
              ),
            ),
          ),
        );

        final fieldFinder = find.byType(CupertinoShiftEnterTextField);
        await tester.enterText(fieldFinder, 'Hello');
        await tester.sendKeyEvent(LogicalKeyboardKey.enter);
        await tester.pump();

        expect(controller.text, 'Hello');
        expect(submitted, isNull);
      });
    });
  });

  group('CupertinoShiftEnterTextFormField', () {
    testWidgets('propagates submitted value through FormField on desktop',
        (tester) async {
      await runWithPlatform(TargetPlatform.macOS, () async {
        final fieldKey = GlobalKey<FormFieldState<String>>();
        String? submitted;

        await tester.pumpWidget(
          CupertinoApp(
            home: CupertinoPageScaffold(
              child: Form(
                child: CupertinoShiftEnterTextFormField(
                  key: fieldKey,
                  onFieldSubmitted: (value) => submitted = value,
                ),
              ),
            ),
          ),
        );

        final fieldFinder = find.byType(CupertinoShiftEnterTextField);
        await tester.enterText(fieldFinder, 'Hello');
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
          CupertinoApp(
            home: CupertinoPageScaffold(
              child: Form(
                child: CupertinoShiftEnterTextFormField(
                  key: fieldKey,
                  onFieldSubmitted: (value) => submitted = value,
                ),
              ),
            ),
          ),
        );

        final fieldFinder = find.byType(CupertinoShiftEnterTextField);
        await tester.enterText(fieldFinder, 'Hello');
        expect(fieldKey.currentState!.value, 'Hello');
        await tester.sendKeyEvent(LogicalKeyboardKey.enter);
        await tester.pump();

        expect(fieldKey.currentState!.value, 'Hello');
        expect(submitted, isNull);
      });
    });
  });
}
