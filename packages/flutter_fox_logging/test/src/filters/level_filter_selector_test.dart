import 'package:flutter/material.dart';
import 'package:flutter_fox_logging/flutter_fox_logging.dart';
import 'package:flutter_fox_logging/src/filters/level_filter_selector.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../faker_extensions.dart';

void main() {
  late List<LogRecord> logs;
  late Level fakeMinimumLevel;
  late LogsController fakeController;

  setUp(() {
    logs = faker.randomGenerator.amount((i) => faker.logRecord(), 100);
    fakeMinimumLevel = faker.logLevel();
    fakeController = LogsController(
      logs: logs,
      filter: Filter(minimumLevel: fakeMinimumLevel),
    );
  });

  Future<void> pumpWidget(WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: LogsControllerProvider.builder(
        builder: (context) => const Material(child: LevelFilterSelector()),
        controller: fakeController,
      ),
    ));
    await tester.pumpAndSettle();
  }

  testWidgets('should contain a dropdown button with selected level as value',
      (tester) async {
    // arrange
    final fakeNewMinimumLevel = faker.randomGenerator
        .element(Level.LEVELS.toList(growable: true)..remove(fakeMinimumLevel));
    final dropdownButtonFinder = find.byType(DropdownButton<Level>);

    // act
    await pumpWidget(tester);

    // assert
    var dropdownButton =
        tester.widget(dropdownButtonFinder) as DropdownButton<Level>;
    expect(dropdownButton.value, fakeMinimumLevel);

    // act
    fakeController.filter.minimumLevel.value = fakeNewMinimumLevel;
    await tester.pumpAndSettle();

    // assert
    dropdownButton =
        tester.widget(dropdownButtonFinder) as DropdownButton<Level>;
    expect(dropdownButton.value, fakeNewMinimumLevel);
  });

  testWidgets('should show contain a list of all levels', (tester) async {
    // arrange
    final dropdownButtonFinder = find.byType(DropdownButton<Level>);

    // act
    await pumpWidget(tester);
    await tester.tap(dropdownButtonFinder);
    await tester.pumpAndSettle();

    // assert
    expect(
      find.widgetWithText(DropdownMenuItem<Level>, Level.ALL.name),
      findsNWidgets(2),
    );
    expect(find.text(Level.OFF.name), findsNWidgets(2));
    expect(find.text(Level.FINEST.name), findsNWidgets(2));
    expect(find.text(Level.FINER.name), findsNWidgets(2));
    expect(find.text(Level.FINE.name), findsNWidgets(2));
    expect(find.text(Level.CONFIG.name), findsNWidgets(2));
    expect(find.text(Level.INFO.name), findsNWidgets(2));
    expect(find.text(Level.WARNING.name), findsNWidgets(2));
    expect(find.text(Level.SEVERE.name), findsNWidgets(2));
    expect(find.text(Level.SHOUT.name), findsNWidgets(2));
  });

  testWidgets('should set the minimum level by tapping an item',
      (tester) async {
    // arrange
    final fakeNewMinimumLevel = faker.randomGenerator
        .element(Level.LEVELS.toList(growable: true)..remove(fakeMinimumLevel));
    final dropdownButtonFinder = find.byType(DropdownButton<Level>);
    final dropdownMenuItemFinder = find.text(fakeNewMinimumLevel.name);

    // act
    await pumpWidget(tester);
    await tester.tap(dropdownButtonFinder);
    await tester.pumpAndSettle();
    await tester.tap(dropdownMenuItemFinder.last);
    await tester.pumpAndSettle();

    // assert
    expect(fakeController.filter.minimumLevel.value, fakeNewMinimumLevel);
  });
}
