import 'package:flutter/foundation.dart';
import 'package:commandy/commandy.dart';
import 'ticker.dart';

class TimerViewModel extends ChangeNotifier {
  TimerViewModel({required Ticker ticker}) : _ticker = ticker {
    _initCommand();
  }

  static const int _duration = 30;
  final Ticker _ticker;

  late StreamCommand<int, NoParams> timerCommand;

  int timeLeft = _duration;

  void _initCommand() {
    timerCommand = StreamCommand<int, NoParams>((_) {
      return _ticker
          .tick(ticks: _duration)
          .map<Result<int>>((value) => Success(value));
    });

    timerCommand.latestResult.addListener(_onResultChanged);
  }

  void start() {
    if (timerCommand.isListening.value) {
      timerCommand.stop();
    }
    timerCommand.start(const NoParams());
  }

  void stop() {
    timerCommand.stop();
    timeLeft = _duration;
    notifyListeners();
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
    super.dispose();
  }
}
