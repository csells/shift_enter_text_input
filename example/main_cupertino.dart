import 'package:flutter/cupertino.dart';
import 'package:shift_enter_text_input/shift_enter_text_input.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) => const CupertinoApp(
    home: CupertinoDemoPage(),
  );
}

class CupertinoDemoPage extends StatefulWidget {
  const CupertinoDemoPage({super.key});

  @override
  State<CupertinoDemoPage> createState() => _CupertinoDemoPageState();
}

class _CupertinoDemoPageState extends State<CupertinoDemoPage> {
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
  Widget build(BuildContext context) => CupertinoPageScaffold(
    navigationBar: const CupertinoNavigationBar(
      middle: Text('Shift+Enter Demo: Cupertino'),
    ),
    child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CupertinoShiftEnterTextField(
              controller: _controller,
              placeholder: 'Type message...',
              onSubmitted: _handleSubmit,
            ),
            const SizedBox(height: 12),
            CupertinoButton.filled(
              onPressed: _handleSubmit,
              child: const Text('Submit'),
            ),
            const SizedBox(height: 12),
            Text(
              _submitted.isEmpty
                  ? 'Submitted: (none)'
                  : 'Submitted: $_submitted',
              style: CupertinoTheme.of(context).textTheme.textStyle,
            ),
          ],
        ),
      ),
    ),
  );
}
