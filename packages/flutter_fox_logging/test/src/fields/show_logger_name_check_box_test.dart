import 'package:flutter/material.dart';
import 'package:flutter_fox_logging/flutter_fox_logging.dart';
import 'package:flutter_fox_logging/src/fields/show_logger_name_check_box.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late LogsController fakeController;

  setUp(() {
    fakeController = LogsController();
  });

  Future<void> pumpWidget(WidgetTester tester) async {
    await tester.pumpWidget(Directionality(
      textDirection: TextDirection.ltr,
      child: Material(
        child: LogsControllerProvider.builder(
          builder: (context) => const ShowLoggerNameCheckBox(),
          controller: fakeController,
        ),
      ),
    ));
    await tester.pumpAndSettle();
  }

  testWidgets('should have a checkbox and a label', (tester) async {
    // arrange
    final checkboxFinder = find.byType(Checkbox);
    final textFinder = find.text('Logger name');

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
    final originalShowLoggerName =
        fakeController.visibleFields.value.loggerName;
    final newShowLoggerName = !originalShowLoggerName;

    // act
    await pumpWidget(tester);

    // assert
    var checkbox = tester.widget(checkboxFinder) as Checkbox;
    expect(checkbox.value, originalShowLoggerName);

    // act
    fakeController.visibleFields.value =
        fakeController.visibleFields.value.copyWith(
      loggerName: newShowLoggerName,
    );
    await tester.pumpAndSettle();

    // assert
    checkbox = tester.widget(checkboxFinder) as Checkbox;
    expect(checkbox.value, newShowLoggerName);
  });
}
