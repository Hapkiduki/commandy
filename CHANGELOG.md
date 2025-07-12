## [0.1.2] - 2025-06-11

### Updated

- Documentation updated
- Command retry added
- Command Dispose updated

## [0.1.1] - 2024-12-17

### Added

- Introduced `ViewModelSelector`, a new widget that listens to a specific property of a `ChangeNotifier`-based ViewModel and rebuilds only when the selected value changes.
- Optimized UI updates by avoiding unnecessary rebuilds.

### Changed

- Updated the Timer example to use the new `ViewModelSelector` for improved efficiency and cleaner code.

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

## [0.1.0+1] - 2024-12-06

### updated

- readme logos updated
