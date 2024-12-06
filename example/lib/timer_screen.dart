import 'package:commandy/commandy.dart';
import 'package:example/timer_viewmodel.dart';
import 'package:flutter/material.dart';

class TimerScreen extends StatelessWidget {
  const TimerScreen({super.key, required this.timerViewModel});

  final TimerViewModel timerViewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Commandy timer example'),
      ),
      body: CommandListener(
        listeners: [
          CommandListenerConfig(
            command: timerViewModel.timerCommand,
            listener: (context, result) {
              if (result is Success<int> && result.data == 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Time's up!")),
                );
              }
            },
          ),
        ],
        child: TimerView(viewModel: timerViewModel),
      ),
    );
  }
}

class TimerView extends StatefulWidget {
  const TimerView({super.key, required this.viewModel});

  final TimerViewModel viewModel;

  @override
  State<TimerView> createState() => _TimerViewState();
}

class _TimerViewState extends State<TimerView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: widget.viewModel,
        builder: (context, _) {
          final timeLeft = widget.viewModel.timeLeft;
          final isRunning = widget.viewModel.timerCommand.isListening.value;

          String displayText;
          if (!isRunning) {
            displayText = 'Press start to begin!';
          } else if (timeLeft > 0) {
            displayText = 'Remaining: $timeLeft s';
          } else {
            displayText = 'Time\'s up!';
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                displayText,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: widget.viewModel.start,
                    child: const Text('Start'),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: widget.viewModel.stop,
                    child: const Text('Stop'),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
