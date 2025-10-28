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
         builder: (state) {
           final effectiveController =
               controller ?? TextEditingController(text: state.value);
           return CupertinoShiftEnterTextField(
             controller: effectiveController,
             placeholder: placeholder,
             onSubmitted: (v) {
               state.didChange(v);
               onFieldSubmitted?.call(v);
             },
           );
         },
       );
}
