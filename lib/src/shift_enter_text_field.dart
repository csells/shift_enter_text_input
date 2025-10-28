import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ShiftEnterTextField extends StatefulWidget {
  const ShiftEnterTextField({
    super.key,
    this.controller,
    this.onSubmitted,
    this.decoration = const InputDecoration(),
    this.maxLines,
    this.onChanged,
  });
  final TextEditingController? controller;
  final ValueChanged<String>? onSubmitted;
  final InputDecoration decoration;
  final int? maxLines;
  final ValueChanged<String>? onChanged;

  @override
  State<ShiftEnterTextField> createState() => _ShiftEnterTextFieldState();
}

class _ShiftEnterTextFieldState extends State<ShiftEnterTextField> {
  late final TextEditingController _controller =
      widget.controller ?? TextEditingController();

  bool get _isShiftPressed =>
      RawKeyboard.instance.keysPressed.contains(LogicalKeyboardKey.shiftLeft) ||
      RawKeyboard.instance.keysPressed.contains(LogicalKeyboardKey.shiftRight);

  @override
  Widget build(BuildContext context) => Shortcuts(
    shortcuts: const {
      SingleActivator(LogicalKeyboardKey.enter, shift: true):
          _InsertNewLineIntent(),
    },
    child: Actions(
      actions: {
        _InsertNewLineIntent: CallbackAction<_InsertNewLineIntent>(
          onInvoke: (_) {
            final v = _controller.value;
            final newText = v.text.replaceRange(
              v.selection.start,
              v.selection.end,
              '\n',
            );
            _controller.value = v.copyWith(
              text: newText,
              selection: TextSelection.collapsed(offset: v.selection.start + 1),
            );
            return null;
          },
        ),
      },
      child: TextField(
        controller: _controller,
        maxLines: widget.maxLines,
        decoration: widget.decoration,
        onChanged: widget.onChanged,
        onSubmitted: (v) {
          if (!_isShiftPressed) widget.onSubmitted?.call(v);
        },
      ),
    ),
  );
}

class _InsertNewLineIntent extends Intent {
  const _InsertNewLineIntent();
}
