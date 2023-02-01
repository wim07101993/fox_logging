import 'package:ansicolor/ansicolor.dart';
import 'package:fox_logging/fox_logging.dart';
import 'package:test/test.dart';

import '../../faker_extensions.dart';
import '../../mocks.dart';

part 'pretty_formatter_test.types.dart';

void main() {
  late PrettyFormatter formatter;
  late _LogLevelToPenConverter mockLevelToPen;
  late _LogLevelToSymbolConverter mockLevelToSymbol;

  setUp(() {
    mockLevelToPen = _LogLevelToPenConverter();
    mockLevelToSymbol = _LogLevelToSymbolConverter();

    formatter = PrettyFormatter(
      levelToPen: mockLevelToPen,
      levelToSymbol: mockLevelToSymbol,
    );
  });

  group('constructor', () {
    test('should set properties', () {
      // arrange
      final fakePrintTime = faker.randomGenerator.boolean();

      // act
      formatter = PrettyFormatter(
        printTime: fakePrintTime,
        levelToPen: mockLevelToPen,
        levelToSymbol: mockLevelToSymbol,
      );

      // assert
      expect(formatter.printTime, fakePrintTime);
      expect(formatter.levelToPen, mockLevelToPen);
      expect(formatter.levelToSymbol, mockLevelToSymbol);
    });

    test('should set default `levelToPen` if no parameters', () {
      // arrange
      final mockLevelToSymbol = MockConverter<Level, String>();
      final fakePrintTime = faker.randomGenerator.boolean();

      // act
      formatter = PrettyFormatter(
        printTime: fakePrintTime,
        levelToSymbol: mockLevelToSymbol,
      );

      // assert
      expect(formatter.levelToPen, isA<LogLevelToAnsiPenConverter>());
    });

    test('should set default `levelToSymbol` if no parameters', () {
      // arrange
      final mockLevelToPen = MockConverter<Level, AnsiPen>();
      final fakePrintTime = faker.randomGenerator.boolean();

      // act
      formatter = PrettyFormatter(
        printTime: fakePrintTime,
        levelToPen: mockLevelToPen,
      );

      // assert
      expect(formatter.levelToSymbol, isA<LogLevelToSymbolConverter>());
    });

    test('should set default `printTime` if no parameters', () {
      // arrange
      final mockLevelToPen = MockConverter<Level, AnsiPen>();
      final mockLevelToSymbol = MockConverter<Level, String>();

      // act
      formatter = PrettyFormatter(
        levelToPen: mockLevelToPen,
        levelToSymbol: mockLevelToSymbol,
      );

      // assert
      expect(formatter.printTime, true);
    });
  });

  group('format', () {
    group('with printTime', () {
      test('should format with thin lines', () {
        // act
        final fakeRecord = LogRecord(
          faker.randomGenerator.element([
            Level.FINEST,
            Level.FINER,
            Level.FINE,
            Level.CONFIG,
            Level.INFO,
            Level.WARNING,
          ]),
          faker.lorem.sentence(),
          faker.lorem.word(),
          faker.lorem.sentence(),
          StackTrace.fromString(faker.lorem.sentence()),
          null,
          faker.lorem.sentence(),
        );
        final formatted = formatter.format(fakeRecord);

        // assert
        expect(formatted, '''
┌───────────────────────────────────────────────────────────────────────────────
│ ${mockLevelToSymbol.convert(fakeRecord.level)}  ${fakeRecord.message}
│ Payload: ${fakeRecord.object}
│ Error: ${fakeRecord.error}
├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
│ Time: ${fakeRecord.time.toIso8601String()} │ Logger: ${fakeRecord.loggerName}
├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
│ ${fakeRecord.stackTrace}
└───────────────────────────────────────────────────────────────────────────────''');
      });

      test('should format with thick lines', () {
        // act
        final fakeRecord = LogRecord(
          faker.randomGenerator.element([Level.SEVERE, Level.SHOUT]),
          faker.lorem.sentence(),
          faker.lorem.word(),
          faker.lorem.sentence(),
          StackTrace.fromString(faker.lorem.sentence()),
          null,
          faker.lorem.sentence(),
        );
        final formatted = formatter.format(fakeRecord);

        // assert
        expect(formatted, '''
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
┃ ${mockLevelToSymbol.convert(fakeRecord.level)}  ${fakeRecord.message}
┃ Payload: ${fakeRecord.object}
┃ Error: ${fakeRecord.error}
┠───────────────────────────────────────────────────────────────────────────────
┃ Time: ${fakeRecord.time.toIso8601String()} │ Logger: ${fakeRecord.loggerName}
┠───────────────────────────────────────────────────────────────────────────────
┃ ${fakeRecord.stackTrace}
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━''');
      });
    });

    group('without printTime', () {
      setUp(() {
        formatter = PrettyFormatter(
          printTime: false,
          levelToPen: mockLevelToPen,
          levelToSymbol: mockLevelToSymbol,
        );
      });

      test('should format with thin lines', () {
        // act
        final fakeRecord = LogRecord(
          faker.randomGenerator.element([
            Level.FINEST,
            Level.FINER,
            Level.FINE,
            Level.CONFIG,
            Level.INFO,
            Level.WARNING,
          ]),
          faker.lorem.sentence(),
          faker.lorem.word(),
          faker.lorem.sentence(),
          StackTrace.fromString(faker.lorem.sentence()),
          null,
          faker.lorem.sentence(),
        );
        final formatted = formatter.format(fakeRecord);

        // assert
        expect(formatted, '''
┌───────────────────────────────────────────────────────────────────────────────
│ ${mockLevelToSymbol.convert(fakeRecord.level)}  ${fakeRecord.message}
│ Payload: ${fakeRecord.object}
│ Error: ${fakeRecord.error}
├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
│ Logger: ${fakeRecord.loggerName}
├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
│ ${fakeRecord.stackTrace}
└───────────────────────────────────────────────────────────────────────────────''');
      });

      test('should format with thick lines', () {
        // act
        final fakeRecord = LogRecord(
          faker.randomGenerator.element([Level.SEVERE, Level.SHOUT]),
          faker.lorem.sentence(),
          faker.lorem.word(),
          faker.lorem.sentence(),
          StackTrace.fromString(faker.lorem.sentence()),
          null,
          faker.lorem.sentence(),
        );
        final formatted = formatter.format(fakeRecord);

        // assert
        expect(formatted, '''
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
┃ ${mockLevelToSymbol.convert(fakeRecord.level)}  ${fakeRecord.message}
┃ Payload: ${fakeRecord.object}
┃ Error: ${fakeRecord.error}
┠───────────────────────────────────────────────────────────────────────────────
┃ Logger: ${fakeRecord.loggerName}
┠───────────────────────────────────────────────────────────────────────────────
┃ ${fakeRecord.stackTrace}
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━''');
      });
    });

    group('without error', () {
      test('should format with thin lines', () {
        // act
        final fakeRecord = LogRecord(
          faker.randomGenerator.element([
            Level.FINEST,
            Level.FINER,
            Level.FINE,
            Level.CONFIG,
            Level.INFO,
            Level.WARNING,
          ]),
          faker.lorem.sentence(),
          faker.lorem.word(),
          null,
          null,
          null,
          faker.lorem.sentence(),
        );
        final formatted = formatter.format(fakeRecord);

        // assert
        expect(formatted, '''
┌───────────────────────────────────────────────────────────────────────────────
│ ${mockLevelToSymbol.convert(fakeRecord.level)}  ${fakeRecord.message}
│ Payload: ${fakeRecord.object}
├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
│ Time: ${fakeRecord.time.toIso8601String()} │ Logger: ${fakeRecord.loggerName}
└───────────────────────────────────────────────────────────────────────────────''');
      });

      test('should format with thick lines', () {
        // act
        final fakeRecord = LogRecord(
          faker.randomGenerator.element([Level.SEVERE, Level.SHOUT]),
          faker.lorem.sentence(),
          faker.lorem.word(),
          null,
          null,
          null,
          faker.lorem.sentence(),
        );
        final formatted = formatter.format(fakeRecord);

        // assert
        expect(formatted, '''
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
┃ ${mockLevelToSymbol.convert(fakeRecord.level)}  ${fakeRecord.message}
┃ Payload: ${fakeRecord.object}
┠───────────────────────────────────────────────────────────────────────────────
┃ Time: ${fakeRecord.time.toIso8601String()} │ Logger: ${fakeRecord.loggerName}
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━''');
      });
    });

    group('without logger name', () {
      test('should format with thin lines', () {
        // act
        final fakeRecord = LogRecord(
          faker.randomGenerator.element([
            Level.FINEST,
            Level.FINER,
            Level.FINE,
            Level.CONFIG,
            Level.INFO,
            Level.WARNING,
          ]),
          faker.lorem.sentence(),
          '',
          faker.lorem.sentence(),
          StackTrace.fromString(faker.lorem.sentence()),
          null,
          faker.lorem.sentence(),
        );
        final formatted = formatter.format(fakeRecord);

        // assert
        expect(formatted, '''
┌───────────────────────────────────────────────────────────────────────────────
│ ${mockLevelToSymbol.convert(fakeRecord.level)}  ${fakeRecord.message}
│ Payload: ${fakeRecord.object}
│ Error: ${fakeRecord.error}
├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
│ Time: ${fakeRecord.time.toIso8601String()}
├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
│ ${fakeRecord.stackTrace}
└───────────────────────────────────────────────────────────────────────────────''');
      });

      test('should format with thick lines', () {
        // act
        final fakeRecord = LogRecord(
          faker.randomGenerator.element([Level.SEVERE, Level.SHOUT]),
          faker.lorem.sentence(),
          '',
          faker.lorem.sentence(),
          StackTrace.fromString(faker.lorem.sentence()),
          null,
          faker.lorem.sentence(),
        );
        final formatted = formatter.format(fakeRecord);

        // assert
        expect(formatted, '''
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
┃ ${mockLevelToSymbol.convert(fakeRecord.level)}  ${fakeRecord.message}
┃ Payload: ${fakeRecord.object}
┃ Error: ${fakeRecord.error}
┠───────────────────────────────────────────────────────────────────────────────
┃ Time: ${fakeRecord.time.toIso8601String()}
┠───────────────────────────────────────────────────────────────────────────────
┃ ${fakeRecord.stackTrace}
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━''');
      });
    });

    group('without payload', () {
      test('should format with thin lines', () {
        // act
        final fakeRecord = LogRecord(
          faker.randomGenerator.element([
            Level.FINEST,
            Level.FINER,
            Level.FINE,
            Level.CONFIG,
            Level.INFO,
            Level.WARNING,
          ]),
          faker.lorem.sentence(),
          faker.lorem.word(),
          faker.lorem.sentence(),
          StackTrace.fromString(faker.lorem.sentence()),
        );
        final formatted = formatter.format(fakeRecord);

        // assert
        expect(formatted, '''
┌───────────────────────────────────────────────────────────────────────────────
│ ${mockLevelToSymbol.convert(fakeRecord.level)}  ${fakeRecord.message}
│ Error: ${fakeRecord.error}
├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
│ Time: ${fakeRecord.time.toIso8601String()} │ Logger: ${fakeRecord.loggerName}
├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
│ ${fakeRecord.stackTrace}
└───────────────────────────────────────────────────────────────────────────────''');
      });

      test('should format with thick lines', () {
        // act
        final fakeRecord = LogRecord(
          faker.randomGenerator.element([Level.SEVERE, Level.SHOUT]),
          faker.lorem.sentence(),
          faker.lorem.word(),
          faker.lorem.sentence(),
          StackTrace.fromString(faker.lorem.sentence()),
        );
        final formatted = formatter.format(fakeRecord);

        // assert
        expect(formatted, '''
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
┃ ${mockLevelToSymbol.convert(fakeRecord.level)}  ${fakeRecord.message}
┃ Error: ${fakeRecord.error}
┠───────────────────────────────────────────────────────────────────────────────
┃ Time: ${fakeRecord.time.toIso8601String()} │ Logger: ${fakeRecord.loggerName}
┠───────────────────────────────────────────────────────────────────────────────
┃ ${fakeRecord.stackTrace}
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━''');
      });
    });
  });
}
