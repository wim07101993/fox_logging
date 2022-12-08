import 'package:flutter/material.dart';
import 'package:flutter_fox_logging/flutter_fox_logging.dart';
import 'package:flutter_fox_logging/src/filters/level_filter_selector.dart';
import 'package:flutter_fox_logging/src/filters/logger_selector.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late LogsController fakeController;

  setUp(() {
    fakeController = LogsController();
  });

  group('normal test', () {
    test('should set fields', () {
      // act
      final widget = FilterScreen(controller: fakeController);

      // assert
      expect(widget.controller, fakeController);
    });
  });

  group('widget tests', () {
    Future<void> pumpFilterScreen(WidgetTester tester) async {
      // act
      await tester.pumpWidget(
        MaterialApp(home: FilterScreen(controller: fakeController)),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('should have app-bar with back-button and title',
        (tester) async {
      // arrange
      final findBackButton = find.byType(BackButton);
      final findTitle = find.text('Filter');

      // act
      await pumpFilterScreen(tester);

      // assert
      expect(findBackButton, findsOneWidget);
      expect(findTitle, findsOneWidget);
    });

    testWidgets('should have check-boxes for different fields', (tester) async {
      // arrange
      final findLevelFilter = find.byType(LevelFilterSelector);
      final findLoggerSelector = find.byType(LoggerSelector);

      // act
      await pumpFilterScreen(tester);

      // assert
      expect(findLevelFilter, findsOneWidget);
      expect(findLoggerSelector, findsOneWidget);
    });

    testWidgets('should provide controller to other widgets in the tree',
        (tester) async {
      // arrange
      const originalLevel = Level.FINEST;
      const newLevel = Level.CONFIG;
      fakeController.filter.minimumLevel.value = Level.FINEST;
      final findDropdownButton = find.byType(DropdownButtonFormField<Level>);
      await pumpFilterScreen(tester);

      // assert
      var dropdown = tester.widgetList(findDropdownButton).first
          as DropdownButtonFormField<Level>;
      expect(dropdown.initialValue, originalLevel);

      // act
      fakeController.filter.minimumLevel.value = newLevel;
      await tester.pumpAndSettle();

      // assert
      dropdown = tester.widgetList(findDropdownButton).first
          as DropdownButtonFormField<Level>;
      expect(dropdown.initialValue, newLevel);
    });
  });
}
