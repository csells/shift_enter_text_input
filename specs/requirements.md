# shift_enter_text_input Requirements

The `shift_enter_text_input` package provides drop-in replacements for Flutter's
`TextField`, `TextFormField`, `CupertinoTextField`, and
`CupertinoTextFormField`.  
It introduces **Shift+Enter for inserting newlines** and **Enter for submitting
text**, maintaining consistent behavior across Web, Desktop, and Mobile
platforms.

Inspired by [this comment on
GitHub](https://github.com/flutter/flutter/pull/167952#issuecomment-2902534156).

## Goals
1. Provide **cross-platform consistency** for text input behavior.
2. Preserve **full API compatibility** with Flutter’s built-in text fields.
3. Ensure **IME (mobile keyboard) compatibility** without breaking expected
   mobile behaviors.
4. Offer both **Material** and **Cupertino** design language variants.

## Functional Requirements

### 1. Shift+Enter Behavior
- **Desktop / Web:** Inserts a newline instead of submitting.
- **Mobile (Android / iOS):** Ignored since IMEs don't emit shift modifiers.
  Default newline behavior remains.

### 2. Enter Behavior
- **Desktop / Web:** Calls the `onSubmitted` callback unless Shift is pressed.
- **Mobile:** Uses native IME Enter key handling (newline or "done").

### 3. Drop-in Compatibility
Each replacement widget must:
- Mirror its Flutter counterpart’s constructor parameters.
- Support all features: `decoration`, `maxLines`, `controller`, `focusNode`,
  `onChanged`, etc.
- Work identically when swapped with a stock widget.

### 4. Platform Support
| Platform | Supported | Notes                                                    |
| -------- | --------- | -------------------------------------------------------- |
| iOS      | ✅         | Uses `CupertinoTextField`                                |
| Android  | ✅         | Native IME newline support                               |
| Web      | ✅         | Keyboard shortcuts handled via `Shortcuts` and `Actions` |
| macOS    | ✅         | Fully functional                                         |
| Windows  | ✅         | Fully functional                                         |
| Linux    | ✅         | Fully functional                                         |

### 5. Design System Variants
- **Material:** `ShiftEnterTextField`, `ShiftEnterTextFormField`
- **Cupertino:** `CupertinoShiftEnterTextField`,
  `CupertinoShiftEnterTextFormField`

### 6. Dependencies
- Flutter SDK ≥ 3.0.0
- No third-party dependencies

### 7. Example App
- Demonstrates both Material and Cupertino variants side by side.
- Shows visual feedback on submission.
- Minimal setup: `flutter run` from the example directory.

## Non-Functional Requirements

### 1. Performance
- Must not introduce noticeable latency or frame drops during typing.
- Avoid excessive rebuilds or state tracking.

### 2. Reliability
- Shortcuts and Actions must always take precedence over default Enter handling.
- Edge cases (e.g., multi-line selections, cursor positions) should behave
  consistently.

### 3. Maintainability
- Each variant is implemented in its own file for modularity.
- Single intent class (`_InsertNewLineIntent`) per widget for clarity.
- Uses only stable Flutter APIs.

### 4. Testability
- Widgets should be testable using `WidgetTester.sendKeyEvent()` for Enter and
  Shift+Enter combinations.
- Example app doubles as a manual integration test.

## Acceptance Criteria

1. ✅ Shift+Enter inserts a newline on web/desktop.
2. ✅ Enter triggers `onSubmitted` (unless Shift is held).
3. ✅ Widgets compile and behave identically to native
   `TextField`/`TextFormField`.
4. ✅ Example app builds and runs on all supported platforms.
5. ✅ No external dependencies.
