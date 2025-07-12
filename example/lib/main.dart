import 'dart:developer';

import 'package:commandy/commandy.dart';
import 'package:example/main_viewmodel.dart';
import 'package:example/ticker.dart';
import 'package:example/timer_screen.dart';
import 'package:example/timer_viewmodel.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3: true,
      ),
      home: MyHomePage(
        viewModel: MainViewModel(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.viewModel});

  final MainViewModel viewModel;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void dispose() {
    widget.viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CommandListener(
      listeners: [
        CommandListenerConfig(
            command: widget.viewModel.incrementCommand,
            listener: (context, result) {
              if (result is FailureResult<int>) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(result.failure.message)),
                );
              }
            })
      ],
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Commandy example'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
              ),
              ValueListenableBuilder(
                valueListenable: widget.viewModel.incrementCommand.result,
                builder: (context, result, child) {
                  final counter = result?.fold(
                    (value) => value,
                    (failure) {
                      log(failure.message, name: 'Main');
                    },
                  );
                  return Text(
                    '${counter ?? widget.viewModel.counter}',
                    style: Theme.of(context).textTheme.headlineMedium,
                  );
                },
              ),
              const SizedBox(height: 10),
              FilledButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TimerScreen(
                        timerViewModel: TimerViewModel(
                          ticker: const Ticker(),
                        ),
                      ),
                    ),
                  );
                },
                child: const Text('Timer example'),
              )
            ],
          ),
        ),
        floatingActionButton: ValueListenableBuilder(
          valueListenable: widget.viewModel.incrementCommand.isExecuting,
          builder: (context, loading, child) => FloatingActionButton(
            onPressed: loading
                ? null
                : () =>
                    widget.viewModel.incrementCommand.execute(const NoParams()),
            tooltip: 'Increment',
            child: loading
                ? const CircularProgressIndicator()
                : const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}
