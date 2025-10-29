import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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
    this.onChanged,
    this.focusNode,
    this.maxLines,
    this.textInputAction,
    this.enabled = true,
  });

  /// Controls the text being edited.
  final TextEditingController? controller;

  /// Optional placeholder displayed when the field is empty.
  final String? placeholder;

  /// Called when Enter is pressed without Shift.
  final ValueChanged<String>? onSubmitted;

  /// Called whenever the field's text changes.
  final ValueChanged<String>? onChanged;

  /// Optional focus node for the text field.
  final FocusNode? focusNode;

  /// Maximum line count for the field. Set to `null` for multiline input.
  final int? maxLines;

  /// Action button to display on the soft keyboard.
  final TextInputAction? textInputAction;

  /// Whether the field is enabled.
  final bool enabled;

  @override
  State<CupertinoShiftEnterTextField> createState() =>
      _CupertinoShiftEnterTextFieldState();
}

class _CupertinoShiftEnterTextFieldState
    extends State<CupertinoShiftEnterTextField> {
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
        child: CupertinoTextField(
          controller: _controller,
          focusNode: widget.focusNode,
          maxLines: widget.maxLines,
          placeholder: widget.placeholder,
          onChanged: widget.onChanged,
          enabled: widget.enabled,
          textInputAction: widget.textInputAction,
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
