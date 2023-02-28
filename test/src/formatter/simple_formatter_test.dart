import 'dart:async';
import 'dart:convert';

import 'package:ansicolor/ansicolor.dart';
import 'package:fox_logging/fox_logging.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../faker_extensions.dart';
import '../../mocks.dart';

part 'simple_formatter_test.types.dart';

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

    test('should write date and time', () {
      // arrange
      formatter = SimpleFormatter();
      fakeLogRecord = faker.logRecord();

      // act
      final formatted = formatter.format(fakeLogRecord);

      // assert
      expect(formatted, contains(fakeLogRecord.time.toIso8601String()));
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

    late AnsiPen mockPen;

    late List<LogRecord> inputs;
    late List<String> expected;

    setUp(() {
      mockToPen = MockConverter();
      mockPen = _MockAnsiPen();

      when(() => mockToPen.convert(any())).thenReturn(mockPen);
      when(() => mockPen.call(any()))
          .thenAnswer((i) => i.positionalArguments[0] as String);

      formatter = SimpleFormatter(printTime: false, levelToPen: mockToPen);

      inputs = [
        LogRecord(Level.FINEST, 'This is a verbose message', 'Test'),
        LogRecord(Level.FINER, 'This is a debug message', 'Test'),
        LogRecord(Level.FINE, 'This is a fine message', 'Test'),
        LogRecord(Level.CONFIG, 'App configuration successful', ''),
        LogRecord(Level.INFO, 'App started', ''),
        LogRecord(Level.WARNING, 'What out, type errors ahead', ''),
        LogRecord(
          Level.SEVERE,
          'Type error',
          'Error logger',
          TypeError(),
          StackTrace.current,
          Zone.current,
          Object(),
        ),
        LogRecord(Level.SHOUT, 'I told you there were type errors ahead', ''),
      ];

      expected = [
        mockToPen.convert(Level.FINEST)('[V] Test: This is a verbose message'),
        mockToPen.convert(Level.FINER)('[D] Test: This is a debug message'),
        mockToPen.convert(Level.FINE)('[F] Test: This is a fine message'),
        '${mockToPen.convert(Level.CONFIG)('[C]')} App configuration successful',
        '${mockToPen.convert(Level.INFO)('[I]')} App started',
        '${mockToPen.convert(Level.WARNING)('[W]')} What out, type errors ahead',
        mockToPen.convert(Level.SEVERE)(
          '[E] Error logger: Type error ERROR: ${TypeError()}',
        ),
        mockToPen.convert(Level.SHOUT)(
          '[WTF] I told you there were type errors ahead',
        ),
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
