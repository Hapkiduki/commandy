import 'package:commandy/commandy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class MockViewModel extends ChangeNotifier {
  String _name = 'Initial Name';
  String get name => _name;

  int _counter = 0;
  int get counter => _counter;

  void updateName(String newName) {
    _name = newName;
    notifyListeners();
  }

  void incrementCounter() {
    _counter++;
    notifyListeners();
  }
}

void main() {
  group('ViewModelSelector Tests', () {
    late MockViewModel viewModel;

    setUp(() {
      viewModel = MockViewModel();
    });

    testWidgets(
      'should rebuild widget when selected property changes',
      (WidgetTester tester) async {
        var buildCount = 0;

        await tester.pumpWidget(
          MaterialApp(
            home: ViewModelSelector<MockViewModel, String>(
              viewModel: viewModel,
              selector: (vm) => vm.name,
              builder: (context, name) {
                buildCount++;
                return Text(name, textDirection: TextDirection.ltr);
              },
            ),
          ),
        );

        expect(find.text('Initial Name'), findsOneWidget);
        expect(buildCount, 1);

        viewModel.updateName('Updated Name');
        await tester.pump();

        expect(find.text('Updated Name'), findsOneWidget);
        expect(buildCount, 2);

        viewModel.incrementCounter();
        await tester.pump();

        expect(find.text('Updated Name'), findsOneWidget);
        expect(buildCount, 2);
      },
    );

    testWidgets(
      'should not rebuild widget when unrelated property changes',
      (WidgetTester tester) async {
        var buildCount = 0;

        await tester.pumpWidget(
          MaterialApp(
            home: ViewModelSelector<MockViewModel, int>(
              viewModel: viewModel,
              selector: (vm) => vm.counter,
              builder: (context, counter) {
                buildCount++;
                return Text(
                  'Counter: $counter',
                  textDirection: TextDirection.ltr,
                );
              },
            ),
          ),
        );

        expect(find.text('Counter: 0'), findsOneWidget);
        expect(buildCount, 1);

        viewModel.updateName('Unrelated Change');
        await tester.pump();

        expect(find.text('Counter: 0'), findsOneWidget);
        expect(buildCount, 1);

        viewModel.incrementCounter();
        await tester.pump();

        expect(find.text('Counter: 1'), findsOneWidget);
        expect(buildCount, 2);
      },
    );
  });
}
