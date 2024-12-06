import 'package:flutter_test/flutter_test.dart';
import 'package:example/timer_viewmodel.dart';
import 'package:example/ticker.dart';

void main() {
  group('TimerViewModel', () {
    late TimerViewModel viewModel;

    setUp(() {
      viewModel = TimerViewModel(ticker: const Ticker());
    });

    test('initial timeLeft is 30', () {
      expect(viewModel.timeLeft, 30);
    });

    test('start timer and wait a few seconds', () async {
      viewModel.start();
      expect(viewModel.timerCommand.isListening.value, true);

      await Future.delayed(const Duration(seconds: 3));

      expect(viewModel.timeLeft, inInclusiveRange(27, 27));

      viewModel.stop();
      expect(viewModel.timerCommand.isListening.value, false);

      expect(viewModel.timeLeft, 30);
    });
  });
}
