import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

/// A Cupertino text field that inserts a newline with Shift+Enter and
/// submits on Enter.
class CupertinoShiftEnterTextField extends StatefulWidget {
  /// Creates a [CupertinoShiftEnterTextField].
  ///
  /// The [controller] shares text editing state with other widgets when
  /// provided. The [placeholder] is forwarded to the underlying
  /// [CupertinoTextField], and [onSubmitted] is invoked when Enter is pressed
  /// without the Shift modifier.
  const CupertinoShiftEnterTextField({
    super.key,
    this.controller,
    this.placeholder,
    this.onSubmitted,
  });

  /// Controls the text being edited.
  final TextEditingController? controller;

  /// Optional placeholder displayed when the field is empty.
  final String? placeholder;

  /// Called when Enter is pressed without Shift.
  final ValueChanged<String>? onSubmitted;

  @override
  State<CupertinoShiftEnterTextField> createState() =>
      _CupertinoShiftEnterTextFieldState();
}

class _CupertinoShiftEnterTextFieldState
    extends State<CupertinoShiftEnterTextField> {
  late final TextEditingController _controller =
      widget.controller ?? TextEditingController();

  bool get _isShiftPressed {
    final keys = HardwareKeyboard.instance.logicalKeysPressed;
    return keys.contains(LogicalKeyboardKey.shiftLeft) ||
        keys.contains(LogicalKeyboardKey.shiftRight);
  }

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
