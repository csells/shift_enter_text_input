import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class CupertinoShiftEnterTextField extends StatefulWidget {
  const CupertinoShiftEnterTextField({
    super.key,
    this.controller,
    this.placeholder,
    this.onSubmitted,
  });
  final TextEditingController? controller;
  final String? placeholder;
  final ValueChanged<String>? onSubmitted;

  @override
  State<CupertinoShiftEnterTextField> createState() =>
      _CupertinoShiftEnterTextFieldState();
}

class _CupertinoShiftEnterTextFieldState
    extends State<CupertinoShiftEnterTextField> {
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
      child: CupertinoTextField(
        controller: _controller,
        placeholder: widget.placeholder,
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
