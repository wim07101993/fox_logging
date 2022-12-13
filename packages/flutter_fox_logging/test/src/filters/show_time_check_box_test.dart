import 'package:flutter/material.dart';
import 'package:flutter_fox_logging/flutter_fox_logging.dart';
import 'package:flutter_fox_logging/src/filters/logger_check_box.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../faker_extensions.dart';

void main() {
  late String fakeLoggerName;
  late bool fakeLoggerEnabled;
  late LogsController fakeController;

  setUp(() {
    fakeLoggerName = faker.lorem.word();
    fakeLoggerEnabled = faker.randomGenerator.boolean();

    fakeController = LogsController();
    fakeController.filter.loggers.value = {fakeLoggerName: fakeLoggerEnabled};
  });

  Future<void> pumpWidget(WidgetTester tester) async {
    await tester.pumpWidget(Directionality(
      textDirection: TextDirection.ltr,
      child: Material(
        child: LogsControllerProvider.builder(
          builder: (context) => LoggerCheckBox(logger: fakeLoggerName),
          controller: fakeController,
        ),
      ),
    ));
    await tester.pumpAndSettle();
  }

  testWidgets('should have a checkbox and a label', (tester) async {
    // arrange
    final checkboxFinder = find.byType(Checkbox);
    final textFinder = find.text(fakeLoggerName);

    // act
    await pumpWidget(tester);

    // assert
    expect(checkboxFinder, findsOneWidget);
    expect(textFinder, findsOneWidget);
  });

  testWidgets('should listen for value of checkbox to controller',
      (tester) async {
    // arrange
    final checkboxFinder = find.byType(Checkbox);
    final fakeNewLoggerEnabled = !fakeLoggerEnabled;

    // act
    await pumpWidget(tester);

    // assert
    var checkbox = tester.widget(checkboxFinder) as Checkbox;
    expect(checkbox.value, fakeLoggerEnabled);

    // act
    final oldLoggers =
        Map<String, bool>.from(fakeController.filter.loggers.value);
    oldLoggers[fakeLoggerName] = fakeNewLoggerEnabled;
    fakeController.filter.loggers.value = oldLoggers;
    await tester.pumpAndSettle();

    // assert
    checkbox = tester.widget(checkboxFinder) as Checkbox;
    expect(checkbox.value, fakeNewLoggerEnabled);
  });

  testWidgets('should change filter if checkbox value changes', (tester) async {
    // arrange
    final checkboxFinder = find.byType(Checkbox);

    // act
    await pumpWidget(tester);
    await tester.tap(checkboxFinder);
    await tester.pumpAndSettle();

    // assert
    expect(fakeController.filter.loggers.value[fakeLoggerName],
        !fakeLoggerEnabled);
  });
}
