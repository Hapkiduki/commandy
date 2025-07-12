import 'package:commandy/src/base/base_command.dart';
import 'package:commandy/src/base/result.dart';
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
    var attempts = 0;

    while (attempts <= maxRetries) {
      try {
        final res = await _action(params);
        result.value = res;
      } catch (e) {
        attempts++;
        if (attempts > maxRetries) rethrow;
        await Future<void>.delayed(Duration(milliseconds: 500 * attempts));
      } finally {
        isExecuting.value = false;
      }
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
