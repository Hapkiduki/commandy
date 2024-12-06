import 'package:flutter_test/flutter_test.dart';
import 'package:commandy/commandy.dart';
import 'package:example/main_viewmodel.dart';

void main() {
  group('MainViewModel', () {
    late MainViewModel viewModel;

    setUp(() {
      viewModel = MainViewModel();
    });

    test('initial counter value is 0', () {
      expect(viewModel.counter, 0);
    });

    test('execute incrementCommand once returns Success(1)', () async {
      await viewModel.incrementCommand.execute(const NoParams());
      final result = viewModel.incrementCommand.result.value;

      expect(result, isA<Success<int>>());
      expect((result as Success<int>).data, 1);
      expect(viewModel.counter, 1);
    });

    test('execute incrementCommand multiple times until failure', () async {
      await viewModel.incrementCommand.execute(const NoParams());
      expect(viewModel.incrementCommand.result.value, isA<Success<int>>());
      expect((viewModel.incrementCommand.result.value as Success<int>).data, 1);
      expect(viewModel.counter, 1);

      await viewModel.incrementCommand.execute(const NoParams());
      expect(viewModel.incrementCommand.result.value, isA<Success<int>>());
      expect((viewModel.incrementCommand.result.value as Success<int>).data, 2);
      expect(viewModel.counter, 2);

      await viewModel.incrementCommand.execute(const NoParams());
      expect(viewModel.incrementCommand.result.value, isA<Success<int>>());
      expect((viewModel.incrementCommand.result.value as Success<int>).data, 3);
      expect(viewModel.counter, 3);

      await viewModel.incrementCommand.execute(const NoParams());
      final result = viewModel.incrementCommand.result.value;
      expect(result, isA<FailureResult<int>>());
      final failure = (result as FailureResult<int>).failure;
      expect(failure.message, 'Counter is more than 2!');

      expect(viewModel.counter, 0);
    });
  });
}
