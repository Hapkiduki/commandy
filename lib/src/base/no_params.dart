/// {@template no_params}
/// A class that represents the absence of parameters for a command.
///
/// Use `NoParams` when you want to execute a command that doesn't
/// require any input.
/// This allows you to maintain a consistent `Command<T, Params>` interface,
/// even when certain commands do not need parameters.
///
/// By using `NoParams`, you avoid:
/// - Passing `null` as a parameter, which can be less explicit.
/// - Creating separate classes or logic for commands without parameters.
///
/// Example:
/// ```dart
/// final incrementCommand = Command<int, NoParams>((_) async {
///   // No parameters needed here
///   return Success(42);
/// });
///
/// await incrementCommand.execute(const NoParams());
/// // The command runs without needing any input.
/// ```
/// {@endtemplate}
class NoParams {
  /// {@macro no_params}
  const NoParams();
}
