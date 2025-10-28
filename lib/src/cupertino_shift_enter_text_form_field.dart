import 'package:flutter/cupertino.dart';
import 'cupertino_shift_enter_text_field.dart';

class CupertinoShiftEnterTextFormField extends FormField<String> {
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
