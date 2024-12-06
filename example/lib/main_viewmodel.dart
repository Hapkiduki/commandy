import 'package:commandy/commandy.dart';

class MainViewModel {
  MainViewModel() {
    incrementCommand = Command<int, NoParams>(_increment);
  }
  int _counter = 0;

  int get counter => _counter;

  late final Command<int, NoParams> incrementCommand;

  Future<Result<int>> _increment(NoParams _) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    _counter += 1;
    if (_counter > 3) {
      _counter = 0;
      return const FailureResult(
        Failure(message: 'Counter is more than 2!'),
      );
    }
    return Success(_counter);
  }
}
