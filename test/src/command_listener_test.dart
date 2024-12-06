import 'package:commandy/commandy.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('CommandListener calls listener callbacks when result changes',
      (tester) async {
    final command = Command<int, int>((param) async => Success(param * 2));
    Result<dynamic>? receivedResult;

    final widget = CommandListener(
      listeners: [
        CommandListenerConfig(
          command: command,
          listener: (context, result) {
            receivedResult = result;
          },
        ),
      ],
      child: const SizedBox(),
    );

    await tester.pumpWidget(widget);

    expect(receivedResult, isNull);

    await command.execute(10);

    await tester.pump();

    expect(receivedResult, isA<Success<int>>());
    expect((receivedResult! as Success<int>).data, 20);
  });

  testWidgets('CommandListener updates listeners when command changes',
      (tester) async {
    final command1 = Command<int, int>((param) async => Success(param));
    final command2 = Command<int, int>((param) async => Success(param + 10));

    Result<dynamic>? receivedResult1;
    Result<dynamic>? receivedResult2;

    Widget buildWidget(List<CommandListenerConfig> configs) {
      return CommandListener(
        listeners: configs,
        child: const SizedBox(),
      );
    }

    await tester.pumpWidget(
      buildWidget([
        CommandListenerConfig(
          command: command1,
          listener: (context, result) {
            receivedResult1 = result;
          },
        ),
      ]),
    );

    await command1.execute(5);
    await tester.pump();
    expect(receivedResult1, isA<Success<int>>());
    expect((receivedResult1! as Success<int>).data, 5);

    await tester.pumpWidget(
      buildWidget([
        CommandListenerConfig(
          command: command2,
          listener: (context, result) {
            receivedResult2 = result;
          },
        ),
      ]),
    );

    await command2.execute(5);
    await tester.pump();
    expect(receivedResult2, isA<Success<int>>());
    expect((receivedResult2! as Success<int>).data, 15);

    await command1.execute(10);
    await tester.pump();

    expect(receivedResult2, isNotNull);
  });
}
