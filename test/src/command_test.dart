import 'package:commandy/commandy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Command', () {
    test('execute sets isExecuting to true and false correctly', () async {
      final command = Command<int, int>((param) async {
        await Future<void>.delayed(const Duration(milliseconds: 10));
        return Success(param * 2);
      });

      expect(command.isExecuting.value, false);
      expect(command.result.value, isNull);

      final future = command.execute(21);
      expect(command.isExecuting.value, true);

      await future;
      expect(command.isExecuting.value, false);
    });

    test('execute returns Success result', () async {
      final command = Command<int, int>((param) async {
        return Success(param + 1);
      });

      await command.execute(5);
      expect(command.result.value, isA<Success<int>>());
      expect((command.result.value! as Success<int>).data, 6);
    });

    test('execute returns FailureResult on error', () async {
      final command = Command<int, int>((param) async {
        try {
          throw Exception('Test error');
        } catch (e, s) {
          return FailureResult<int>(
            Failure(
              message: 'Error $e',
              exception: e,
              stackTrace: s,
            ),
          );
        }
      });

      await command.execute(10);
      final result = command.result.value;
      expect(result, isA<FailureResult<int>>());
      expect(
        (result! as FailureResult<int>).failure.message,
        contains('Test error'),
      );
    });

    test('Command executes successfully with NoParams', () async {
      final incrementCommand = Command<int, NoParams>((_) async {
        return const Success(42);
      });

      expect(incrementCommand.isExecuting.value, false);
      expect(incrementCommand.result.value, isNull);

      await incrementCommand.execute(const NoParams());

      expect(incrementCommand.isExecuting.value, false);
      final result = incrementCommand.result.value;
      expect(result, isA<Success<int>>());
      expect((result! as Success<int>).data, 42);
    });

    test('cleanResult resets the result', () async {
      final command = Command<int, int>((param) async {
        return Success(param + 1);
      });

      await command.execute(5);
      expect(command.result.value, isNotNull);

      command.cleanResult();
      expect(command.result.value, isNull);
    });
  });
}
