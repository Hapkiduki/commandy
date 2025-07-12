import 'package:commandy/commandy.dart';
import 'package:flutter/foundation.dart';

/// {@template command}
/// A class that facilitates interaction with a ViewModel or UseCase.
/// It encapsulates an asynchronous action and exposes its state and result.
///
/// `Params` is the type of parameters the action needs, use `NoParams` if none.
/// {@endtemplate}
class Command<T, Params> implements BaseCommand<T> {
  /// {@macro command}
  Command(this._action, {this.maxRetries = 0});

  /// The asynchronous action to be executed.
  final Future<Result<T>> Function(Params) _action;

  /// When an error occurs allow to retry
  final int maxRetries;

  /// Indicates whether the action is currently executing.
  final ValueNotifier<bool> isExecuting = ValueNotifier<bool>(false);

  /// The result of the last executed action.
  final ValueNotifier<Result<T>?> result = ValueNotifier<Result<T>?>(null);

  /// Executes the action with the given [params].
  ///
  /// Prevents multiple simultaneous executions.
  Future<void> execute(Params params) async {
    if (isExecuting.value) return;

    isExecuting.value = true;
    result.value = null;

    try {
      var attempts = 0;
      Result<T>? lastResult;

      while (attempts <= maxRetries) {
        try {
          final res = await _action(params);
          if (res is Success<T>) {
            result.value = res;
            return; // Or break; if you want to continue for some reason
          } else {
            // Treat FailureResult as retryable
            lastResult = res;
          }
        } catch (e, s) {
          // Convert unhandled exceptions to FailureResult
          lastResult = FailureResult<T>(
            Failure(message: 'Execution failed', exception: e, stackTrace: s),
          );
        }

        attempts++;
        if (attempts > maxRetries) {
          result.value = lastResult; // Set the last failure
          return;
        }

        await Future<void>.delayed(Duration(milliseconds: 500 * attempts));
      }
    } finally {
      isExecuting.value = false;
    }
  }

  /// Clears the last result and resets executing state.
  void cleanResult() {
    isExecuting.value = false;
    result.value = null;
  }

  /// Disposes resources.
  @override
  void dispose() {
    isExecuting.dispose();
    result.dispose();
  }

  @override
  ValueListenable<Result<T>?> get resultNotifier => result;
}
