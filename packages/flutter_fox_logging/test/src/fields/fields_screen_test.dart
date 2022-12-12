import 'package:flutter/material.dart';
import 'package:flutter_fox_logging/flutter_fox_logging.dart';
import 'package:flutter_fox_logging/src/fields/show_icons_check_box.dart';
import 'package:flutter_fox_logging/src/fields/show_logger_name_check_box.dart';
import 'package:flutter_fox_logging/src/fields/show_time_check_box.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late LogsController fakeController;

  setUp(() {
    fakeController = LogsController();
  });

  group('normal test', () {
    test('should set fields', () {
      // act
      final widget = FieldsScreen(controller: fakeController);

      // assert
      expect(widget.controller, fakeController);
    });
  });

  group('widget tests', () {
    Future<void> pumpFieldsScreen(WidgetTester tester) async {
      // act
      await tester.pumpWidget(
        MaterialApp(home: FieldsScreen(controller: fakeController)),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('should have app-bar with back-button and title',
        (tester) async {
      // arrange
      final findBackButton = find.byType(BackButton);
      final findTitle = find.text('Visible fields');

      // act
      await pumpFieldsScreen(tester);

      // assert
      expect(findBackButton, findsOneWidget);
      expect(findTitle, findsOneWidget);
    });

    testWidgets('should have check-boxes for different fields', (tester) async {
      // arrange
      final findIconCheckBox = find.byType(ShowIconCheckBox);
      final findLoggerNameCheckBox = find.byType(ShowLoggerNameCheckBox);
      final findTimeCheckBox = find.byType(ShowTimeCheckBox);

      // act
      await pumpFieldsScreen(tester);

      // assert
      expect(findIconCheckBox, findsOneWidget);
      expect(findLoggerNameCheckBox, findsOneWidget);
      expect(findTimeCheckBox, findsOneWidget);
    });

    testWidgets('should provide controller to other widgets in the tree',
        (tester) async {
      // arrange
      fakeController.visibleFields.value = const FieldVisibilitiesData(
        loggerName: false,
        icon: false,
        time: false,
      );
      final findCheckbox = find.byType(Checkbox);
      await pumpFieldsScreen(tester);

      // assert
      var checkBox = tester.widgetList(findCheckbox).first as Checkbox;
      expect(checkBox.value, false);

      // act
      fakeController.visibleFields.value = const FieldVisibilitiesData(
        loggerName: true,
        icon: true,
        time: true,
      );
      await tester.pumpAndSettle();

      // assert
      checkBox = tester.widgetList(findCheckbox).first as Checkbox;
      expect(checkBox.value, true);
    });
  });
}
