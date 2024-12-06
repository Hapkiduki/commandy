import 'package:commandy/src/base/base_command.dart';
import 'package:commandy/src/base/result.dart';
import 'package:flutter/widgets.dart';

/// {@template command_listener_config}
/// Configuration class for a command listener.
/// Contains the command to listen to and the corresponding listener callback.
/// {@endtemplate}
class CommandListenerConfig {
  /// {@macro command_listener_config}
  const CommandListenerConfig({
    required this.command,
    required this.listener,
  });

  /// The command to listen to.
  final BaseCommand<dynamic> command;

  /// Callback executed when the command's result changes.
  final void Function(BuildContext context, Result<dynamic>? result) listener;
}

/// {@template command_listener}
/// A widget that listens to multiple commands and executes callbacks when
/// their results change.
///
/// It listens to the `resultNotifier` of each command and invokes the provided
/// listener callback
/// whenever the result changes.
/// {@endtemplate}
class CommandListener extends StatefulWidget {
  /// {@macro command_listener}
  const CommandListener({
    required this.listeners,
    required this.child,
    super.key,
  });

  /// A list of [CommandListenerConfig] containing the commands
  /// and their listeners.
  final List<CommandListenerConfig> listeners;

  /// The child widget to display.
  final Widget child;

  @override
  State<CommandListener> createState() => _CommandListenerState();
}

class _CommandListenerState extends State<CommandListener> {
  final Map<BaseCommand<dynamic>, VoidCallback> _listeners = {};

  @override
  void initState() {
    super.initState();
    _addListeners(widget.listeners);
  }

  @override
  void didUpdateWidget(covariant CommandListener oldWidget) {
    super.didUpdateWidget(oldWidget);

    final oldCommands = oldWidget.listeners.map((e) => e.command).toSet();
    final newCommands = widget.listeners.map((e) => e.command).toSet();

    final removedCommands = oldCommands.difference(newCommands);
    final addedCommands = newCommands.difference(oldCommands);

    // Remove old listeners
    for (final command in removedCommands) {
      final listener = _listeners[command];
      if (listener != null) {
        command.resultNotifier.removeListener(listener);
        _listeners.remove(command);
      }
    }

    // Add new listeners
    for (final config in widget.listeners) {
      if (addedCommands.contains(config.command)) {
        _addListener(config);
      }
    }
  }

  @override
  void dispose() {
    _removeAllListeners();
    super.dispose();
  }

  void _addListeners(List<CommandListenerConfig> configs) {
    for (final config in configs) {
      _addListener(config);
    }
  }

  void _addListener(CommandListenerConfig config) {
    void listener() => _onResultEmitted(config);
    config.command.resultNotifier.addListener(listener);
    _listeners[config.command] = listener;
  }

  void _removeAllListeners() {
    for (final entry in _listeners.entries) {
      entry.key.resultNotifier.removeListener(entry.value);
    }
    _listeners.clear();
  }

  void _onResultEmitted(CommandListenerConfig config) {
    config.listener(context, config.command.resultNotifier.value);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
