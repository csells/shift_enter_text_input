# shift_enter_text_input

Flutter text inputs that treat Shift+Enter as "insert newline" and Enter as
"submit", without sacrificing the APIs and look-and-feel of the stock widgets.

## What It Does
- Drop-in replacements for `TextField`, `TextFormField`, `CupertinoTextField`,
  and `CupertinoTextFormField`.
- Aligns keyboard behavior across Web, Desktop, and Mobile (Enter submits,
  Shift+Enter inserts a newline).
- Keeps constructors and configuration identical to the Flutter originals, so
  existing code keeps working.
- Ships with both Material (`ShiftEnterTextField`, `ShiftEnterTextFormField`)
  and Cupertino (`CupertinoShiftEnterTextField`,
  `CupertinoShiftEnterTextFormField`) variants.

## Getting Started
1. Add the package to your `pubspec.yaml` once it is published (for local
   development use a path dependency).
2. Run `flutter pub get`.
3. Import the widget you need and swap it in place.

```dart
import 'package:shift_enter_text_input/shift_enter_text_field.dart';

class MessageBox extends StatelessWidget {
  const MessageBox({super.key});

  @override
  Widget build(BuildContext context) {
    return ShiftEnterTextField(
      maxLines: null,
      onSubmitted: (value) {
        // Handle the submitted text when Enter is pressed.
      },
    );
  }
}
```

## Example App
- Run `flutter run` from the `example` directory to see Material and Cupertino
  widgets side-by-side.
- The example shows submission feedback and lets you verify Shift+Enter vs Enter
  behavior on every platform.

## Platform Support
| Platform                              | Status | Notes                                                              |
| ------------------------------------- | ------ | ------------------------------------------------------------------ |
| iOS / Android                         | ✅      | Uses native IME handling; Shift modifiers are ignored as expected. |
| Web / Desktop (macOS, Windows, Linux) | ✅      | Keyboard shortcuts wired via `Shortcuts` and `Actions`.            |

Contributions are welcome! Please open issues or pull requests with reproduction
steps and platform details when reporting keyboard discrepancies.
