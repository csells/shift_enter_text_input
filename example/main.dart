import 'package:flutter/material.dart';
import 'package:shift_enter_text_input/shift_enter_text_input.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Shift+Enter Demo',
    home: Scaffold(
      appBar: AppBar(title: const Text('Shift+Enter Demo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Material ShiftEnterTextField:'),
            ShiftEnterTextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Type message...',
              ),
              maxLines: null,
              onSubmitted: (v) => debugPrint('Submitted: $v'),
            ),
            const SizedBox(height: 24),
            const Text('Cupertino ShiftEnterTextField:'),
            const SizedBox(height: 8),
            const CupertinoTextFieldDemo(),
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
