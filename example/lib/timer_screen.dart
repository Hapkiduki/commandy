import 'dart:developer';

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

class TimerView extends StatelessWidget {
  const TimerView({super.key, required this.viewModel});

  final TimerViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ViewModelSelector<TimerViewModel, int>(
            viewModel: viewModel,
            selector: (viewModel) => viewModel.timeLeft,
            builder: (context, timeLeft) {
              log('escuchando', name: 'timeleft');
              return Text(
                timeLeft > 0 ? 'Remaining: $timeLeft s' : 'Time\'s up!',
                style: Theme.of(context).textTheme.headlineMedium,
              );
            },
          ),
          const SizedBox(height: 20),
          ViewModelSelector<TimerViewModel, bool>(
            viewModel: viewModel,
            selector: (viewModel) => viewModel.timerCommand.isListening.value,
            builder: (context, isRunning) {
              log('escuchando', name: 'timer');
              return Text(
                isRunning ? 'Timer is running...' : 'Press start to begin!',
                style: Theme.of(context).textTheme.bodyLarge,
              );
            },
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  viewModel.startCommand.execute(const NoParams());
                },
                child: const Text('Start'),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  viewModel.stopCommand.execute(const NoParams());
                },
                child: const Text('Stop'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
