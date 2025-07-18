# Commandy

<p align="center">
<img src="https://raw.githubusercontent.com/hapkiduki/commandy/master/commandy.svg" alt="Commandy Logo" width="150"/>
</p>

<div align="center">
  <a href="https://pub.dev/packages/very_good_analysis">
    <img src="https://img.shields.io/badge/style-very_good_analysis-B22C89.svg" alt="style: very good analysis"/>
  </a>
  <a href="https://pub.dev/packages/commandy">
    <img src="https://img.shields.io/pub/v/commandy.svg" alt="commandy package"/>
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
    <img src="https://raw.githubusercontent.com/hapkiduki/commandy/master/coverage_badge.svg" alt="Coverage Badge"/>
  </a>
  <a href="https://github.com/hapkiduki/commandy">
    <img src="https://raw.githubusercontent.com/hapkiduki/commandy/master/commandy_logo.svg" alt="Commandy Library" width="100"/>
  </a>
</div>

**Commandy** is a Flutter package designed to streamline the execution and management of asynchronous commands, while providing a clear and consistent way to handle success, failure, and state changes. It helps you abstract away the complexity of asynchronous actions, making your code more modular, testable, and maintainable.

## Key Features 🚀

- **Unified Result Handling**: Uses a `Result` model with `Success<T>` and `FailureResult<T>` variants to represent operation outcomes clearly. This encourages a functional approach to error handling and makes your code easier to reason about.
- **Asynchronous Commands**: `Command<T, Params>` encapsulates an asynchronous action, notifies execution state changes (`isExecuting`), and delivers the outcome as a `Result<T>` through a `ValueNotifier`. This pattern makes it simple to integrate async logic into your ViewModels or UseCases.
- **Stream-Based Commands**: `StreamCommand<T, Params>` handles actions that return a `Stream<Result<T>>`, automatically managing subscriptions and providing updates via `ValueNotifier`. This is ideal for continuously updating data sources, such as real-time queries or sensor feeds.
- **Command Listener for UI**: The `CommandListener` widget easily integrates into Flutter UI code. It listens to multiple commands and triggers callbacks when results change, allowing the UI layer to react immediately to new data or errors.
- **NoParams for Simplicity**: Provides a convenient way to manage commands that do not require parameters, avoiding null values or unnecessary complexity.
- **State Management Ready**: While Commandy focuses on commands, it can also be used as a lightweight state management solution. By encapsulating your business logic and state changes in commands, you get a clean and testable approach to managing application state.
- **Automatic Retries**: Optional `maxRetries` in `Command` for handling transient failures with exponential backoff.
- **Memory Management**: Proper disposal of notifiers and subscriptions to prevent leaks.

---

## Installation 💻

Add Commandy to your `pubspec.yaml`:

```yaml
dependencies:
  commandy: ^0.1.21
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

Use `result.fold(onSuccess: ..., onFailure: ...)` for handling.

### NoParams Class 🛠️

**`NoParams`** is a lightweight class that represents the absence of parameters for a command. It helps maintain a consistent `Command<T, Params>` interface even when no parameters are required.

#### Example Usage:

```dart
final incrementCommand = Command<int, NoParams>((_) async {
  await Future.delayed(const Duration(seconds: 1));
  return Success(42);
});

// Execute the command
await incrementCommand.execute(const NoParams());
```

This avoids passing `null` and ensures clarity and consistency in your codebase.

### Command

Encapsulates an asynchronous action and updates its state via `ValueNotifier`s:

- `isExecuting`: A `ValueNotifier<bool>` indicating if the command is still running.
- `result`: A `ValueNotifier<Result<T>?>` holding the last result.

Use `Command` for one-shot operations like login requests or data fetching.

- **Retries**: Pasa `maxRetries` en el constructor para reintentar en errores.
  Ejemplo:
  ```dart
  final flakyCommand = Command<int, int>((param) async {
    if (Random().nextBool()) throw Exception('Fail');
    return Success(param * 2);
  }, maxRetries: 3);
  ```

### StreamCommand

Works with streams and manages ongoing updates. Call `start(params)` to begin listening and `stop()` to cancel the subscription. Subscriptions are auto-cancelled on completion or error.

### CommandListener

Simplifies UI integration by reacting to command result changes. Instead of manually listening to `ValueNotifier`s, use `CommandListener` to handle updates efficiently.

### Disposal and Memory Management

Los comandos usan ValueNotifiers y suscripciones que deben disponerse para evitar memory leaks. Llama a `command.dispose()` en el `dispose()` de tu ViewModel o controller.

Ejemplo en ViewModel:

```dart
class MyViewModel {
  late Command<int, NoParams> myCommand;
  // ...
  void dispose() {
    myCommand.dispose();
  }
}
```

---

#### Advanced Features ⚡

### ViewModelSelector 🧩

The **`ViewModelSelector`** is a powerful utility for selectively rebuilding Flutter widgets based on specific properties of a `ChangeNotifier`-based ViewModel. It optimizes UI updates by ensuring that only the widgets depending on the selected value are rebuilt, avoiding unnecessary widget rebuilds when other properties in the ViewModel change.

#### Key Features:

- **Selective Rebuilding**: Extracts a specific property from the ViewModel using a `selector` function and only triggers a rebuild when that property changes (using equality checks).
- **Integration with ChangeNotifier**: Works seamlessly with your existing ViewModels, which extend `ChangeNotifier`.
- **Efficient and Modular**: Allows finer control of UI updates without requiring external libraries or tools. For complex types, ensure the selected value is Equatable.

#### Example Usage:

**1. Create a ViewModel:**

```dart
class MyViewModel extends ChangeNotifier {
  String _name = 'John Doe';
  int _counter = 0;

  String get name => _name;
  int get counter => _counter;

  void updateName(String newName) {
    _name = newName;
    notifyListeners();
  }

  void incrementCounter() {
    _counter++;
    notifyListeners();
  }
}
```

**2. Use ViewModelSelector in Your Widget:**

```dart
final myViewModel = MyViewModel();

ViewModelSelector<MyViewModel, String>(
  viewModel: myViewModel,
  selector: (vm) => vm.name, // Watch only the `name` property
  builder: (context, name) {
    return Text('Name: $name');
  },
);

ViewModelSelector<MyViewModel, int>(
  viewModel: myViewModel,
  selector: (vm) => vm.counter, // Watch only the `counter` property
  builder: (context, counter) {
    return Text('Counter: $counter');
  },
);
```

#### Benefits:

- Ensures UI efficiency by rebuilding only the widgets affected by state changes.
- Simple and clean integration into existing `ChangeNotifier` architectures.
- Great for modularizing UI updates when working with complex ViewModels. Note: For lists or objects, use Equatable for proper equality.

### Advanced Usage: Command Chaining

Encadena comandos ejecutando uno después del resultado de otro.

Ejemplo:

```dart
command1.execute(params).then((_) {
  if (command1.result.value is Success) {
    command2.execute(otherParams);
  }
});
```

O usa listeners para chaining reactivo.

### Parametrized Commands with Retries

Ejemplo complejo:

```dart
final apiCommand = Command<String, String>((url) async {
  // Fetch logic with potential failure
}, maxRetries: 2);
await apiCommand.execute('https://api.example.com');
```

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

### Retry Example

```dart
final flakyCommand = Command<int, NoParams>((_) async {
  if (Random().nextBool()) throw Exception('Flaky');
  return Success(100);
}, maxRetries: 2);

await flakyCommand.execute(const NoParams());
```

### Full Implementation

Check the [example](example/) folder for a full implementation of both the **counter** and **timer** examples. Includes UI integration and detailed logic.

---

## Additional Resources 📚

Learn more about the Command pattern and its practical applications:

- [Architecting Flutter Apps the Right Way: A Practical Guide with Command Pattern and MVVM](https://medium.com/@hapkiduki/architecting-flutter-apps-the-right-way-a-practical-guide-with-command-pattern-and-mvvm-55fbff068186)
- [Flutter's Official Case Study on App Architecture](https://docs.flutter.dev/app-architecture/case-study)
- Flutter Documentation on Performance: [flutter.dev/performance](https://flutter.dev/performance)

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
- Tests cover retries, disposal, and concurrent executions.

---

## Contributing 🤝

We welcome contributions! Feel free to open issues, suggest enhancements, or submit pull requests. Please follow our coding style and ensure all tests pass.

---

## License 📄

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
