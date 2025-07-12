import 'package:flutter/foundation.dart';
import 'package:commandy/commandy.dart';
import 'ticker.dart';

class TimerViewModel extends ChangeNotifier {
  TimerViewModel({required Ticker ticker}) : _ticker = ticker {
    _initCommands();
  }

  static const int _duration = 30;
  final Ticker _ticker;

  late StreamCommand<int, NoParams> timerCommand;
  late Command<void, NoParams> startCommand;
  late Command<void, NoParams> stopCommand;

  int timeLeft = _duration;

  void _initCommands() {
    timerCommand = StreamCommand<int, NoParams>((_) {
      return _ticker
          .tick(ticks: _duration)
          .map<Result<int>>((value) => Success(value));
    });

    timerCommand.latestResult.addListener(_onResultChanged);
    startCommand = Command<void, NoParams>(_start);
    stopCommand = Command<void, NoParams>(_stop);
  }

  Future<Result<void>> _start(NoParams _) async {
    if (timerCommand.isListening.value) {
      timerCommand.stop();
    }
    timerCommand.start(const NoParams());
    return const Success(null);
  }

  Future<Result<void>> _stop(NoParams _) async {
    timerCommand.stop();
    timeLeft = _duration;
    notifyListeners();
    return const Success(null);
  }

  void _onResultChanged() {
    final result = timerCommand.latestResult.value;
    if (result is Success<int>) {
      timeLeft = result.data;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    timerCommand.latestResult.removeListener(_onResultChanged);
    timerCommand.dispose();
    startCommand.dispose();
    stopCommand.dispose();
    super.dispose();
  }
}
