import 'package:flutter/material.dart';
import 'package:flutter_fox_logging/flutter_fox_logging.dart';
import 'package:flutter_fox_logging/src/fields/show_time_check_box.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../faker_extensions.dart';

void main() {
  late bool fakeValue;
  late LogsController fakeController;

  setUp(() {
    fakeValue = faker.randomGenerator.boolean();

    fakeController = LogsController();
    fakeController.visibleFields.value =
        fakeController.visibleFields.value.copyWith(
      time: fakeValue,
    );
  });

  Future<void> pumpWidget(WidgetTester tester) async {
    await tester.pumpWidget(Directionality(
      textDirection: TextDirection.ltr,
      child: Material(
        child: LogsControllerProvider.builder(
          builder: (context) => const ShowTimeCheckBox(),
          controller: fakeController,
        ),
      ),
    ));
    await tester.pumpAndSettle();
  }

  testWidgets('should have a checkbox and a label', (tester) async {
    // arrange
    final checkboxFinder = find.byType(Checkbox);
    final textFinder = find.text('Time');

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
    final fakeNewValue = !fakeValue;

    // act
    await pumpWidget(tester);

    // assert
    var checkbox = tester.widget(checkboxFinder) as Checkbox;
    expect(checkbox.value, fakeValue);

    // act
    fakeController.visibleFields.value =
        fakeController.visibleFields.value.copyWith(
      time: fakeNewValue,
    );
    await tester.pumpAndSettle();

    // assert
    checkbox = tester.widget(checkboxFinder) as Checkbox;
    expect(checkbox.value, fakeNewValue);
  });

  testWidgets('should change of field visibility if checkbox value changes',
      (tester) async {
    // arrange
    final checkboxFinder = find.byType(Checkbox);

    // act
    await pumpWidget(tester);
    await tester.tap(checkboxFinder);
    await tester.pumpAndSettle();

    // assert
    expect(fakeController.visibleFields.value.time, !fakeValue);
  });
}
