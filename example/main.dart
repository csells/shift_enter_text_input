import 'package:flutter/material.dart';
import 'package:shift_enter_text_input/shift_enter_text_input.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Shift+Enter Demo',
    home: Scaffold(
      appBar: AppBar(title: const Text('Shift+Enter Demo: Material')),
      body: ShiftEnterTextField(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Type message...',
        ),
        maxLines: null,
        onSubmitted: (v) => debugPrint('Submitted: $v'),
      ),
    ),
  );
}
