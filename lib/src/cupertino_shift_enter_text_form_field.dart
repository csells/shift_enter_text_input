import 'package:flutter/cupertino.dart';

import 'cupertino_shift_enter_text_field.dart';

/// A [FormField] wrapper for [CupertinoShiftEnterTextField].
class CupertinoShiftEnterTextFormField extends FormField<String> {
  /// Creates a [CupertinoShiftEnterTextFormField] that syncs with a
  /// [TextEditingController] and reports submission via [onFieldSubmitted].
  CupertinoShiftEnterTextFormField({
    super.key,
    TextEditingController? controller,
    String? placeholder,
    ValueChanged<String>? onFieldSubmitted,
  }) : super(
         initialValue: controller?.text ?? '',
         builder: (state) => _CupertinoShiftEnterTextFormFieldBody(
           state: state,
           controller: controller,
           placeholder: placeholder,
           onFieldSubmitted: onFieldSubmitted,
         ),
       );
}

class _CupertinoShiftEnterTextFormFieldBody extends StatefulWidget {
  const _CupertinoShiftEnterTextFormFieldBody({
    required this.state,
    this.controller,
    this.placeholder,
    this.onFieldSubmitted,
  });

  final FormFieldState<String> state;
  final TextEditingController? controller;
  final String? placeholder;
  final ValueChanged<String>? onFieldSubmitted;

  @override
  State<_CupertinoShiftEnterTextFormFieldBody> createState() =>
      _CupertinoShiftEnterTextFormFieldBodyState();
}

class _CupertinoShiftEnterTextFormFieldBodyState
    extends State<_CupertinoShiftEnterTextFormFieldBody> {
  TextEditingController? _internalController;
  TextEditingController? _registeredController;

  TextEditingController get _controller =>
      widget.controller ?? _internalController!;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _internalController =
          TextEditingController(text: widget.state.value ?? '');
    }
    _registerListener();
    _syncStateWithController();
  }

  @override
  void didUpdateWidget(
    covariant _CupertinoShiftEnterTextFormFieldBody oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      if (oldWidget.controller == null && widget.controller != null) {
        _registeredController?.removeListener(_handleControllerChanged);
        _internalController?.dispose();
        _internalController = null;
      } else if (oldWidget.controller != null && widget.controller == null) {
        _internalController =
            TextEditingController(text: widget.state.value ?? '');
      }
      _registerListener();
    } else if (widget.controller == null &&
        widget.state.value != _controller.text) {
      _controller
        ..text = widget.state.value ?? ''
        ..selection = TextSelection.collapsed(
          offset: (widget.state.value ?? '').length,
        );
    }
    _syncStateWithController();
  }

  @override
  void dispose() {
    _registeredController?.removeListener(_handleControllerChanged);
    _internalController?.dispose();
    super.dispose();
  }

  void _registerListener() {
    final controller = _controller;
    if (_registeredController == controller) return;
    _registeredController?.removeListener(_handleControllerChanged);
    _registeredController = controller;
    _registeredController?.addListener(_handleControllerChanged);
  }

  void _handleControllerChanged() {
    final text = _controller.text;
    if (widget.state.value != text) widget.state.didChange(text);
  }

  void _syncStateWithController() {
    _handleControllerChanged();
  }

  @override
  Widget build(BuildContext context) => CupertinoShiftEnterTextField(
    controller: _controller,
    placeholder: widget.placeholder,
    onSubmitted: (value) {
      widget.state.didChange(value);
      widget.onFieldSubmitted?.call(value);
    },
  );
}
