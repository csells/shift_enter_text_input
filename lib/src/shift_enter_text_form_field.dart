import 'package:flutter/material.dart';

import 'shift_enter_text_field.dart';

/// A [FormField] wrapper that wires Shift+Enter submit semantics into form
/// validation flows.
class ShiftEnterTextFormField extends FormField<String> {
  /// Creates a [ShiftEnterTextFormField] that mirrors [TextFormField]'s API.
  ShiftEnterTextFormField({
    super.key,
    TextEditingController? controller,
    InputDecoration decoration = const InputDecoration(),
    ValueChanged<String>? onFieldSubmitted,
  }) : super(
         initialValue: controller?.text ?? '',
         builder: (state) => _ShiftEnterTextFormFieldBody(
           state: state,
           controller: controller,
           decoration: decoration,
           onFieldSubmitted: onFieldSubmitted,
         ),
       );
}

class _ShiftEnterTextFormFieldBody extends StatefulWidget {
  const _ShiftEnterTextFormFieldBody({
    required this.state,
    required this.decoration,
    this.controller,
    this.onFieldSubmitted,
  });

  final FormFieldState<String> state;
  final TextEditingController? controller;
  final InputDecoration decoration;
  final ValueChanged<String>? onFieldSubmitted;

  @override
  State<_ShiftEnterTextFormFieldBody> createState() =>
      _ShiftEnterTextFormFieldBodyState();
}

class _ShiftEnterTextFormFieldBodyState
    extends State<_ShiftEnterTextFormFieldBody> {
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
  void didUpdateWidget(covariant _ShiftEnterTextFormFieldBody oldWidget) {
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
  Widget build(BuildContext context) => ShiftEnterTextField(
    controller: _controller,
    decoration: widget.decoration.copyWith(errorText: widget.state.errorText),
    onSubmitted: (value) {
      widget.state.didChange(value);
      widget.onFieldSubmitted?.call(value);
    },
  );
}
