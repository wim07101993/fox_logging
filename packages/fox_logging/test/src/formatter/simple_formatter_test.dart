import 'dart:async';
import 'dart:convert';

import 'package:ansicolor/ansicolor.dart';
import 'package:fox_logging/fox_logging.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../faker_extensions.dart';
import '../../mocks.dart';

void main() {
  late bool fakePrintTime;
  late Converter<Level, AnsiPen> mockToPen;
  late Converter<Level, String> mockToPrefix;

  late SimpleFormatter formatter;

  setUpAll(() {
    registerFallbackValue(const Level('', -1));
  });

  setUp(() {
    fakePrintTime = faker.randomGenerator.boolean();
    mockToPrefix = MockConverter();
    mockToPen = MockConverter();

    formatter = SimpleFormatter(
      printTime: fakePrintTime,
      levelToPen: mockToPen,
      levelToPrefix: mockToPrefix,
    );
  });

  group('constructor', () {
    test(
        'should use default values if no pen and prefix converters are provided',
        () {
      // act
      formatter = SimpleFormatter();

      // assert
      expect(formatter.levelToPen, isA<LogLevelToAnsiPenConverter>());
      expect(formatter.levelToPrefix, isA<LogLevelToAbbreviationConverter>());
    });
  });

  group('format', () {
    late String fakePrefix;
    late AnsiPen fakePen;
    late LogRecord fakeLogRecord;

    setUp(() {
      fakePrefix = faker.lorem.word();
      fakePen = AnsiPen()..cyan();
      fakeLogRecord = faker.logRecord();

      when(() => mockToPen.convert(any())).thenReturn(fakePen);
      when(() => mockToPrefix.convert(any())).thenReturn(fakePrefix);
    });

    test('should use the pen and prefix', () {
      // act
      formatter.format(fakeLogRecord);

      // assert
      verify(() => mockToPen.convert(fakeLogRecord.level));
      verify(() => mockToPrefix.convert(fakeLogRecord.level));
    });
  });

  group('IN <-> OUT tests', () {
    const List<Level> levels = [
      Level.FINEST,
      Level.FINER,
      Level.FINE,
      Level.CONFIG,
      Level.INFO,
      Level.WARNING,
      Level.SEVERE,
      Level.SHOUT,
    ];
    late LogLevelToAnsiPenConverter toPen;
    late List<LogRecord> inputs;
    late List<String> expected;

    setUp(() {
      toPen = LogLevelToAnsiPenConverter();
      formatter = SimpleFormatter(printTime: false, levelToPen: toPen);

      inputs = [
        LogRecord(Level.FINEST, 'This is a verbose message', 'Test'),
        LogRecord(Level.FINER, 'This is a debug message', 'Test'),
        LogRecord(Level.FINE, 'This is a fine message', 'Test'),
        LogRecord(Level.CONFIG, 'App configuration successful', ''),
        LogRecord(Level.INFO, 'App started', ''),
        LogRecord(Level.WARNING, 'What out, type errors ahead', ''),
        LogRecord(Level.SEVERE, 'Type error', 'Error logger', TypeError(),
            StackTrace.current, Zone.current, Object()),
        LogRecord(Level.SHOUT, 'I told you there were type errors ahead', ''),
      ];

      expected = [
        '[V] Test: This is a verbose message',
        '[D] Test: This is a debug message',
        '[F] Test: This is a fine message',
        '[C] App configuration successful',
        '[I] App started',
        '[W] What out, type errors ahead',
        '[E] Error logger: Type error ERROR: ${TypeError()}',
        '[WTF] I told you there were type errors ahead',
      ];
    });

    for (var i = 0; i < levels.length; i++) {
      test('should format ${levels[i]} correctly', () {
        // act
        final result = formatter.format(inputs[i]);

        // assert
        expect(result, expected[i]);
      });
    }
  });
}
