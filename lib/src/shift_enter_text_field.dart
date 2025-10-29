import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A Material [TextField] variant that reserves Shift+Enter for inserting
/// newlines and treats Enter as submit.
class ShiftEnterTextField extends StatefulWidget {
  /// Creates a [ShiftEnterTextField].
  ///
  /// The constructor mirrors [TextField] while layering in Shift+Enter logic.
  /// See [TextField] for parameter behavior.
  const ShiftEnterTextField({
    super.key,
    this.controller,
    this.onSubmitted,
    this.decoration = const InputDecoration(),
    this.maxLines,
    this.onChanged,
  });

  /// Controls the text being edited.
  final TextEditingController? controller;

  /// Invoked when Enter is pressed without Shift.
  final ValueChanged<String>? onSubmitted;

  /// Decoration applied to the underlying [TextField].
  final InputDecoration decoration;

  /// Maximum line count for the field.
  final int? maxLines;

  /// Called whenever the field's text changes.
  final ValueChanged<String>? onChanged;

  @override
  State<ShiftEnterTextField> createState() => _ShiftEnterTextFieldState();
}

class _ShiftEnterTextFieldState extends State<ShiftEnterTextField> {
  late final TextEditingController _controller =
      widget.controller ?? TextEditingController();

  bool get _isMobile =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  bool get _shouldInterceptEnter => !_isMobile;

  bool get _isShiftPressed {
    final keys = HardwareKeyboard.instance.logicalKeysPressed;
    return keys.contains(LogicalKeyboardKey.shiftLeft) ||
        keys.contains(LogicalKeyboardKey.shiftRight);
  }

  void _handleSubmit([String? value]) {
    final text = value ?? _controller.text;
    widget.onSubmitted?.call(text);
  }

  @override
  Widget build(BuildContext context) {
    final shortcuts = <ShortcutActivator, Intent>{
      const SingleActivator(LogicalKeyboardKey.enter, shift: true):
          const _InsertNewLineIntent(),
      if (_shouldInterceptEnter)
        const SingleActivator(LogicalKeyboardKey.enter): const _SubmitIntent(),
      if (_shouldInterceptEnter)
        const SingleActivator(LogicalKeyboardKey.numpadEnter):
            const _SubmitIntent(),
    };

    return Shortcuts(
      shortcuts: shortcuts,
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
                selection:
                    TextSelection.collapsed(offset: v.selection.start + 1),
              );
              return null;
            },
          ),
          if (_shouldInterceptEnter)
            _SubmitIntent: CallbackAction<_SubmitIntent>(
              onInvoke: (_) {
                _handleSubmit();
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
            if (!_isShiftPressed) _handleSubmit(v);
          },
        ),
      ),
    );
  }
}

class _InsertNewLineIntent extends Intent {
  const _InsertNewLineIntent();
}

class _SubmitIntent extends Intent {
  const _SubmitIntent();
}
