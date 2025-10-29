import 'package:flutter/material.dart';
import 'package:shift_enter_text_input/shift_enter_text_input.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) => const MaterialApp(
    title: 'Shift+Enter Demo',
    home: MaterialDemoPage(),
  );
}

class MaterialDemoPage extends StatefulWidget {
  const MaterialDemoPage({super.key});

  @override
  State<MaterialDemoPage> createState() => _MaterialDemoPageState();
}

class _MaterialDemoPageState extends State<MaterialDemoPage> {
  final TextEditingController _controller = TextEditingController();
  String _submitted = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSubmit([String? value]) {
    final text = value ?? _controller.text;
    setState(() {
      _submitted = text;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Shift+Enter Demo: Material')),
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ShiftEnterTextField(
                controller: _controller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Type message...',
                ),
                maxLines: null,
                onSubmitted: _handleSubmit,
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _handleSubmit,
              child: const Text('Submit'),
            ),
            const SizedBox(height: 12),
            Text(
              _submitted.isEmpty
                  ? 'Submitted: (none)'
                  : 'Submitted: $_submitted',
            ),
          ],
        ),
      ),
    ),
  );
}
