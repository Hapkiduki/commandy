// ignore_for_file: public_member_api_docs

import 'package:equatable/equatable.dart';

/// {@template failure}
/// A generic failure representation containing error details.
/// {@endtemplate}
class Failure extends Equatable {
  /// {@macro failure}
  const Failure({
    required this.message,
    this.exception,
    this.stackTrace,
  });

  final String message;
  final Object? exception;
  final StackTrace? stackTrace;

  @override
  List<Object?> get props => [message, exception, stackTrace];
}
