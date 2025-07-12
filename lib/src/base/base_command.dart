import 'package:commandy/src/base/result.dart';
import 'package:flutter/foundation.dart';

/// {@template base_command}
/// An interface that represents a command exposing its latest [Result].
///
/// Implementations like Command and StreamCommand will
/// provide a [ValueListenable<Result<T>?>> to notify changes in their state.
/// {@endtemplate}
abstract interface class BaseCommand<T> {
  /// {@template base_command_resultNotifier}
  /// A [ValueListenable] that notifies listeners when the result changes.
  ///
  /// The value will be `null` if no action has been executed yet.
  /// {@endtemplate}
  ValueListenable<Result<T>?> get resultNotifier;

  /// release the memory to avoid memory leaks
  void dispose();
}
