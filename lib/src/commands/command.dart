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
  Command(this._action);

  /// The asynchronous action to be executed.
  final Future<Result<T>> Function(Params) _action;

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
      final res = await _action(params);
      result.value = res;
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
  void dispose() {
    isExecuting.dispose();
    result.dispose();
  }

  @override
  ValueListenable<Result<T>?> get resultNotifier => result;
}
