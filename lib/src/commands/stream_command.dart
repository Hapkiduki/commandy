import 'dart:async';

import 'package:commandy/commandy.dart';
import 'package:flutter/foundation.dart';

/// {@template stream_command}
/// A class that facilitates interaction with a StreamUseCase.
/// It encapsulates a stream action, exposes its current data and error states,
/// and ensures proper subscription management.
///
/// `Params` is the type of parameters the action needs, use `NoParams` if none.
/// {@endtemplate}
class StreamCommand<T, Params> implements BaseCommand<T> {
  /// {@macro stream_command}
  StreamCommand(this._action);

  /// The stream action to be executed.
  final Stream<Result<T>> Function(Params) _action;

  /// Indicates whether the stream is currently active.
  final ValueNotifier<bool> isListening = ValueNotifier<bool>(false);

  /// The latest result emitted by the stream.
  final ValueNotifier<Result<T>?> latestResult =
      ValueNotifier<Result<T>?>(null);

  StreamSubscription<Result<T>>? _subscription;

  /// Starts listening to the stream with the given [params].
  void start(Params params) {
    if (isListening.value) return;

    isListening.value = true;

    _subscription = _action(params).listen(
      (result) {
        latestResult.value = result;
      },
      onError: (Object error, StackTrace? stackTrace) {
        latestResult.value = FailureResult<T>(
          Failure(
            message: 'Stream error occurred.',
            exception: error,
            stackTrace: stackTrace,
          ),
        );
      },
      onDone: _handleStreamCompletion,
    );
  }

  /// Stops listening to the stream and cancels the subscription.
  void stop() {
    _subscription?.cancel();
    _subscription = null;
    isListening.value = false;
  }

  void _handleStreamCompletion() {
    isListening.value = false;
    _subscription?.cancel();
    _subscription = null;
  }

  /// Disposes resources.
  @override
  void dispose() {
    stop();
    isListening.dispose();
    latestResult.dispose();
  }

  @override
  ValueListenable<Result<T>?> get resultNotifier => latestResult;
}
