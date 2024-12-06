import 'package:commandy/src/base/failure.dart';
import 'package:equatable/equatable.dart';

/// {@template result}
/// A sealed class that represents the result of an operation, which can either
/// be a [Success] containing data, or a [FailureResult] containing a [Failure].
///
/// Use [fold] to handle both success and failure cases in a functional style.
/// {@endtemplate}

sealed class Result<T> extends Equatable {
  /// {@macro result}
  const Result();

  /// Applies one of the provided functions based on whether this instance is
  /// a [Success] or a [FailureResult].
  U fold<U>(
    U Function(T data) onSuccess,
    U Function(Failure failure) onFailure,
  );

  @override
  List<Object?> get props => [];
}

/// {@template success}
/// A subclass of [Result] that represents a successful operation.
/// {@endtemplate}
final class Success<T> extends Result<T> {
  /// {@macro success}
  const Success(this.data);

  /// The data returned by the successful operation.
  final T data;

  @override
  U fold<U>(
    U Function(T data) onSuccess,
    U Function(Failure failure) onFailure,
  ) {
    return onSuccess(data);
  }

  @override
  List<Object?> get props => [data];
}

/// {@template failure_result}
/// A subclass of [Result] that represents a failed operation.
///
/// Contains a [Failure] with detailed error information.
/// {@endtemplate}
final class FailureResult<T> extends Result<T> {
  /// {@macro failure_result}
  const FailureResult(this.failure);

  /// The failure information associated with the error.
  final Failure failure;

  @override
  U fold<U>(
    U Function(T data) onSuccess,
    U Function(Failure failure) onFailure,
  ) {
    return onFailure(failure);
  }

  @override
  List<Object?> get props => [failure];
}
