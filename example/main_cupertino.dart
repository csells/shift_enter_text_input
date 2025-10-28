import 'package:flutter/cupertino.dart';
import 'package:shift_enter_text_input/shift_enter_text_input.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) => const CupertinoApp(
    home: CupertinoPageScaffold(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Shift+Enter Demo: Cupertino'),
            SizedBox(height: 8),
            CupertinoTextFieldDemo(),
          ],
        ),
      ),
    ),
  );
}

class CupertinoTextFieldDemo extends StatelessWidget {
  const CupertinoTextFieldDemo({super.key});

  @override
  Widget build(BuildContext context) => CupertinoShiftEnterTextField(
    placeholder: 'Cupertino style...',
    onSubmitted: (v) => debugPrint('Cupertino submitted: $v'),
  );
}
