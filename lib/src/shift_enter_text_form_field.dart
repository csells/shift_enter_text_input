import 'package:flutter/material.dart';
import 'shift_enter_text_field.dart';

class ShiftEnterTextFormField extends FormField<String> {
  ShiftEnterTextFormField({
    super.key,
    TextEditingController? controller,
    InputDecoration decoration = const InputDecoration(),
    ValueChanged<String>? onFieldSubmitted,
  }) : super(
         initialValue: controller?.text ?? '',
         builder: (state) {
           final effectiveController =
               controller ?? TextEditingController(text: state.value);
           return ShiftEnterTextField(
             controller: effectiveController,
             decoration: decoration.copyWith(errorText: state.errorText),
             onSubmitted: (v) {
               state.didChange(v);
               onFieldSubmitted?.call(v);
             },
           );
         },
       );
}
