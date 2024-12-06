
# Commandy

<p align="center">
<img src="commandy.svg" alt="Commandy Logo" width="150"/>
</p>

<div align="center">
  <a href="https://pub.dev/packages/very_good_analysis">
    <img src="https://img.shields.io/badge/style-very_good_analysis-B22C89.svg" alt="style: very good analysis"/>
  </a>
  <a href="https://opensource.org/licenses/MIT">
    <img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="License: MIT"/>
  </a>
  <img src="https://img.shields.io/badge/Flutter-%E2%9D%A4-blue" alt="Flutter"/>
  <img src="https://img.shields.io/badge/State%20Management-Efficient-success" alt="State Management"/>
  <a href="#examples">
    <img src="https://img.shields.io/badge/Example-Included-009688" alt="Example Included"/>
  </a>
   <a href="https://github.com/hapkiduki/commandy">
    <img src="./coverage_badge.svg" alt="Coverage Badge"/>
  </a>
  <a href="https://github.com/hapkiduki/commandy">
    <img src="./commandy_logo.svg" alt="Commandy Library" width="100"/>
  </a>
</div>


**Commandy** is a Flutter package designed to streamline the execution and management of asynchronous commands, while providing a clear and consistent way to handle success, failure, and state changes. It helps you abstract away the complexity of asynchronous actions, making your code more modular, testable, and maintainable.




## Key Features 🚀

- **Unified Result Handling**:  
  Uses a `Result` model with `Success<T>` and `FailureResult<T>` variants to represent operation outcomes clearly. This encourages a functional approach to error handling and makes your code easier to reason about.

- **Asynchronous Commands**:  
  `Command<T, Params>` encapsulates an asynchronous action, notifies execution state changes (`isExecuting`), and delivers the outcome as a `Result<T>` through a `ValueNotifier`. This pattern makes it simple to integrate async logic into your ViewModels or UseCases.

- **Stream-Based Commands**:  
  `StreamCommand<T, Params>` handles actions that return a `Stream<Result<T>>`, automatically managing subscriptions and providing updates via `ValueNotifier`. This is ideal for continuously updating data sources, such as real-time queries or sensor feeds.

- **Command Listener for UI**:  
  The `CommandListener` widget easily integrates into Flutter UI code. It listens to multiple commands and triggers callbacks when results change, allowing the UI layer to react immediately to new data or errors.

- **NoParams for Simplicity**:  
  Provides a convenient way to manage commands that do not require parameters, avoiding null values or unnecessary complexity.

- **State Management Ready**:  
  While Commandy focuses on commands, it can also be used as a lightweight state management solution. By encapsulating your business logic and state changes in commands, you get a clean and testable approach to managing application state.

---

## Installation 💻

Add Commandy to your `pubspec.yaml`:

```yaml
dependencies:
  commandy: ^0.1.0
```

Then, fetch packages:

```bash
flutter pub get
```

---

## Getting Started

1. **Import the library:**
   ```dart
   import 'package:commandy/commandy.dart';
   ```

2. **Create a Command** that executes your asynchronous logic, for example, fetching data from a repository.  
3. **Bind it to your UI** using a `CommandListener` widget or by calling `execute` and listening to result changes in your ViewModel.

By structuring your app's async operations as Commands returning Results, you can maintain a clean separation of concerns and ensure that logic and UI remain loosely coupled.

---

## Core Concepts

### Result and its Variants

`Result<T>` is a sealed class that represents the outcome of an operation. It has two main variants:

- `Success<T>`: Indicates that the operation completed successfully. Holds the resulting `data`.
- `FailureResult<T>`: Indicates that the operation failed. Holds a `Failure` object with details of the error, including a message, optional exception, and stack trace.

---

### NoParams Class 🛠️

**`NoParams`** is a lightweight class that represents the absence of parameters for a command. It helps maintain a consistent `Command<T, Params>` interface even when no parameters are required.

#### Example Usage:
```dart
final incrementCommand = Command<int, NoParams>((_) async {
  // Increment logic
  await Future.delayed(const Duration(seconds: 1));
  return Success(42);
});

// Execute the command
await incrementCommand.execute(const NoParams());
```

This avoids passing `null` and ensures clarity and consistency in your codebase.

---

### Command

Encapsulates an asynchronous action and updates its state via `ValueNotifier`s:

- `isExecuting`: A `ValueNotifier<bool>` indicating if the command is still running.
- `result`: A `ValueNotifier<Result<T>?>` holding the last result.

Use `Command` for one-shot operations like login requests or data fetching.

---

### StreamCommand

Works with streams and manages ongoing updates. Call `start(params)` to begin listening and `stop()` to cancel the subscription.

---

### CommandListener

Simplifies UI integration by reacting to command result changes. Instead of manually listening to `ValueNotifier`s, use `CommandListener` to handle updates efficiently.

---

## Examples 🎯

### Counter Example

```dart
final incrementCommand = Command<int, NoParams>((_) async {
  // Increment logic
  await Future.delayed(Duration(seconds: 1));
  return Success(42);
});
```

### Timer Example

```dart
final timerCommand = StreamCommand<int, NoParams>((_) {
  return Stream.periodic(Duration(seconds: 1), (x) => 30 - x - 1)
      .take(30)
      .map((value) => Success(value));
});

timerCommand.start(const NoParams());
```

### Full Implementation
Check the [example](example/) folder for a full implementation of both the **counter** and **timer** examples. Includes UI integration and detailed logic.

---
## Additional Resources 📚

Learn more about the Command pattern and its practical applications:

- [Architecting Flutter Apps the Right Way: A Practical Guide with Command Pattern and MVVM](https://medium.com/@hapkiduki/architecting-flutter-apps-the-right-way-a-practical-guide-with-command-pattern-and-mvvm-55fbff068186)
- [Flutter's Official Case Study on App Architecture](https://docs.flutter.dev/app-architecture/case-study)


## Error Handling 🚦

Convert all errors into `FailureResult` instances:

```dart
final safeCommand = Command<int, int>((param) async {
  try {
    if (param < 0) throw Exception('Negative param');
    return Success(param * 2);
  } catch (e, s) {
    return FailureResult<int>(
      Failure(message: 'Error processing param', exception: e, stackTrace: s),
    );
  }
});
```

---

## Testing 🧪

Commandy is test-ready:
- Mock commands to return `Success` or `FailureResult` and verify behavior.
- Use `Stream.fromIterable` for testing `StreamCommand`.
- Integrate `CommandListener` in UI tests with `flutter_test`.

---

## Contributing 🤝

We welcome contributions! Feel free to open issues, suggest enhancements, or submit pull requests. Please follow our coding style and ensure all tests pass.

---

## License 📄

This project is licensed under the MIT License - see the [LICENSE](./LICENSE) file for details.

---


