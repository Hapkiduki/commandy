import 'package:commandy/commandy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Result', () {
    test('Success holds data and fold returns onSuccess value', () {
      const success = Success<int>(42);

      final foldResult = success.fold(
        (data) => 'Data: $data',
        (failure) => 'Error: ${failure.message}',
      );

      expect(foldResult, equals('Data: 42'));
      expect(success.props, equals([42]));
    });

    test('FailureResult holds failure and fold returns onFailure value', () {
      const failure = Failure(message: 'Something went wrong');
      const error = FailureResult<int>(failure);

      final foldResult = error.fold(
        (data) => 'Data: $data',
        (failure) => 'Error: ${failure.message}',
      );

      expect(foldResult, equals('Error: Something went wrong'));
      expect(error.props, equals([failure]));
    });

    test('Success equality', () {
      const s1 = Success<String>('OK');
      const s2 = Success<String>('OK');
      const s3 = Success<String>('NOT_OK');

      expect(s1, equals(s2));
      expect(s1, isNot(equals(s3)));
    });

    test('FailureResult equality', () {
      const f1 = Failure(message: 'Fail');
      const f2 = Failure(message: 'Fail');
      const f3 = Failure(message: 'Different');

      const e1 = FailureResult<String>(f1);
      const e2 = FailureResult<String>(f2);
      const e3 = FailureResult<String>(f3);

      expect(e1, equals(e2));
      expect(e1, isNot(equals(e3)));
    });
  });
}
