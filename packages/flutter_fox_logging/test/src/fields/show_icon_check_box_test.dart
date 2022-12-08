import 'package:flutter/material.dart';
import 'package:flutter_fox_logging/flutter_fox_logging.dart';
import 'package:flutter_fox_logging/src/fields/show_icons_check_box.dart';
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
          builder: (context) => const ShowIconCheckBox(),
          controller: fakeController,
        ),
      ),
    ));
    await tester.pumpAndSettle();
  }

  testWidgets('should have a checkbox and a label', (tester) async {
    // arrange
    final checkboxFinder = find.byType(Checkbox);
    final textFinder = find.text('Icon');

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
    final originalShowIcon = fakeController.visibleFields.value.icon;
    final newShowIcon = !originalShowIcon;

    // act
    await pumpWidget(tester);

    // assert
    var checkbox = tester.widget(checkboxFinder) as Checkbox;
    expect(checkbox.value, originalShowIcon);

    // act
    fakeController.visibleFields.value =
        fakeController.visibleFields.value.copyWith(
      icon: newShowIcon,
    );
    await tester.pumpAndSettle();

    // assert
    checkbox = tester.widget(checkboxFinder) as Checkbox;
    expect(checkbox.value, newShowIcon);
  });
}
