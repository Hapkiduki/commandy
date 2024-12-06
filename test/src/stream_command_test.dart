import 'dart:async';

import 'package:commandy/commandy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StreamCommand', () {
    test('start listening to a stream and receive results', () async {
      final streamCommand = StreamCommand<int, int>((param) {
        return Stream.fromIterable([
          Success(param),
          Success(param + 1),
          Success(param + 2),
        ]);
      });

      expect(streamCommand.isListening.value, false);
      expect(streamCommand.latestResult.value, isNull);

      streamCommand.start(10);
      expect(streamCommand.isListening.value, true);

      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(streamCommand.latestResult.value, isA<Success<int>>());
      expect((streamCommand.latestResult.value! as Success<int>).data, 12);
    });

    test('handles stream errors with FailureResult', () async {
      final streamCommand = StreamCommand<int, int>((param) {
        return Stream<int>.error(Exception('Stream error'))
            .map<Result<int>>(Success.new);
      })
        ..start(5);

      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(streamCommand.latestResult.value, isA<FailureResult<int>>());
      final failure =
          (streamCommand.latestResult.value! as FailureResult<int>).failure;
      expect(failure.message, contains('Stream error occurred'));
    });

    test('stop cancels the subscription', () async {
      final controller = StreamController<Result<int>>();
      final streamCommand =
          StreamCommand<int, int>((param) => controller.stream)..start(5);
      expect(streamCommand.isListening.value, true);

      streamCommand.stop();
      expect(streamCommand.isListening.value, false);
      controller.add(const Success(100));

      expect(streamCommand.latestResult.value, isNull);

      await controller.close();
    });
  });
}
