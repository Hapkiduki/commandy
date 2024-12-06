## [0.1.0] - 2024-12-06
### Added
- Initial implementation of the **Commandy** package.
- `Result` class with subclasses:
  - `Success<T>` to represent successful operations.
  - `FailureResult<T>` to handle errors with detailed information.
- `Command<T, Params>` class:
  - Enables asynchronous actions and notifies the command's state via `ValueNotifier`.
- `StreamCommand<T, Params>` class:
  - Handles stream-based actions with automatic subscription management and error handling.
- `CommandListener` widget:
  - Listens for changes in multiple commands and triggers custom callbacks.
- Comprehensive documentation for all public classes.
- Compatibility with Dart 3 and Flutter.