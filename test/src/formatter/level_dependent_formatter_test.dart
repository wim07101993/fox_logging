import 'package:fox_logging/fox_logging.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../faker_extensions.dart';
import '../../mocks.dart';

void main() {
  late LogRecordFormatter mockFinest;
  late LogRecordFormatter mockFiner;
  late LogRecordFormatter mockFine;
  late LogRecordFormatter mockConfig;
  late LogRecordFormatter mockInfo;
  late LogRecordFormatter mockWarning;
  late LogRecordFormatter mockSevere;
  late LogRecordFormatter mockShout;
  late LogRecordFormatter mockAll;
  late LogRecordFormatter mockOff;
  late LogRecordFormatter mockDefault;

  late LevelDependentFormatter formatter;

  setUpAll(() {
    registerFallbackValue(faker.logRecord());
  });

  setUp(() {
    mockFinest = MockLogRecordFormatter();
    mockFiner = MockLogRecordFormatter();
    mockFine = MockLogRecordFormatter();
    mockConfig = MockLogRecordFormatter();
    mockInfo = MockLogRecordFormatter();
    mockWarning = MockLogRecordFormatter();
    mockSevere = MockLogRecordFormatter();
    mockShout = MockLogRecordFormatter();
    mockAll = MockLogRecordFormatter();
    mockOff = MockLogRecordFormatter();
    mockDefault = MockLogRecordFormatter();

    formatter = LevelDependentFormatter(
      finest: mockFinest,
      finer: mockFiner,
      fine: mockFine,
      config: mockConfig,
      info: mockInfo,
      warning: mockWarning,
      severe: mockSevere,
      shout: mockShout,
      all: mockAll,
      off: mockOff,
      defaultFormatter: mockDefault,
    );
  });

  group('constructor', () {
    test('should set the fields', () {
      expect(formatter.finest, mockFinest);
      expect(formatter.finer, mockFiner);
      expect(formatter.fine, mockFine);
      expect(formatter.config, mockConfig);
      expect(formatter.info, mockInfo);
      expect(formatter.warning, mockWarning);
      expect(formatter.severe, mockSevere);
      expect(formatter.shout, mockShout);
      expect(formatter.all, mockAll);
      expect(formatter.off, mockOff);
      expect(formatter.defaultFormatter, mockDefault);
    });
  });

  group('convert', () {
    test('should format with the formatter corresponding with finest', () {
      // arrange
      final fakeRecord = LogRecord(
        Level.FINEST,
        faker.lorem.sentence(),
        faker.lorem.word(),
      );
      final fakeFormatted = faker.lorem.sentence();
      when(() => mockFinest.format(any())).thenReturn(fakeFormatted);

      // act & assert
      expect(formatter(fakeRecord), fakeFormatted);
    });

    test('should format with the formatter corresponding with finer', () {
      // arrange
      final fakeRecord = LogRecord(
        Level.FINER,
        faker.lorem.sentence(),
        faker.lorem.word(),
      );
      final fakeFormatted = faker.lorem.sentence();
      when(() => mockFiner.format(any())).thenReturn(fakeFormatted);

      // act & assert
      expect(formatter(fakeRecord), fakeFormatted);
    });

    test('should format with the formatter corresponding with fine', () {
      // arrange
      final fakeRecord = LogRecord(
        Level.FINE,
        faker.lorem.sentence(),
        faker.lorem.word(),
      );
      final fakeFormatted = faker.lorem.sentence();
      when(() => mockFine.format(any())).thenReturn(fakeFormatted);

      // act & assert
      expect(formatter(fakeRecord), fakeFormatted);
    });

    test('should format with the formatter corresponding with config', () {
      // arrange
      final fakeRecord = LogRecord(
        Level.CONFIG,
        faker.lorem.sentence(),
        faker.lorem.word(),
      );
      final fakeFormatted = faker.lorem.sentence();
      when(() => mockConfig.format(any())).thenReturn(fakeFormatted);

      // act & assert
      expect(formatter(fakeRecord), fakeFormatted);
    });

    test('should format with the formatter corresponding with info', () {
      // arrange
      final fakeRecord = LogRecord(
        Level.INFO,
        faker.lorem.sentence(),
        faker.lorem.word(),
      );
      final fakeFormatted = faker.lorem.sentence();
      when(() => mockInfo.format(any())).thenReturn(fakeFormatted);

      // act & assert
      expect(formatter(fakeRecord), fakeFormatted);
    });

    test('should format with the formatter corresponding with warning', () {
      // arrange
      final fakeRecord = LogRecord(
        Level.WARNING,
        faker.lorem.sentence(),
        faker.lorem.word(),
      );
      final fakeFormatted = faker.lorem.sentence();
      when(() => mockWarning.format(any())).thenReturn(fakeFormatted);

      // act & assert
      expect(formatter(fakeRecord), fakeFormatted);
    });

    test('should format with the formatter corresponding with severe', () {
      // arrange
      final fakeRecord = LogRecord(
        Level.SEVERE,
        faker.lorem.sentence(),
        faker.lorem.word(),
      );
      final fakeFormatted = faker.lorem.sentence();
      when(() => mockSevere.format(any())).thenReturn(fakeFormatted);

      // act & assert
      expect(formatter(fakeRecord), fakeFormatted);
    });

    test('should format with the formatter corresponding with shout', () {
      // arrange
      final fakeRecord = LogRecord(
        Level.SHOUT,
        faker.lorem.sentence(),
        faker.lorem.word(),
      );
      final fakeFormatted = faker.lorem.sentence();
      when(() => mockShout.format(any())).thenReturn(fakeFormatted);

      // act & assert
      expect(formatter(fakeRecord), fakeFormatted);
    });

    test('should format with the formatter corresponding with all', () {
      // arrange
      final fakeRecord = LogRecord(
        Level.ALL,
        faker.lorem.sentence(),
        faker.lorem.word(),
      );
      final fakeFormatted = faker.lorem.sentence();
      when(() => mockAll.format(any())).thenReturn(fakeFormatted);

      // act & assert
      expect(formatter(fakeRecord), fakeFormatted);
    });

    test('should format with the formatter corresponding with off', () {
      // arrange
      final fakeRecord = LogRecord(
        Level.OFF,
        faker.lorem.sentence(),
        faker.lorem.word(),
      );
      final fakeFormatted = faker.lorem.sentence();
      when(() => mockOff.format(any())).thenReturn(fakeFormatted);

      // act & assert
      expect(formatter(fakeRecord), fakeFormatted);
    });

    group('with only a default value', () {
      late String fakeFormatted;

      setUp(() {
        formatter = LevelDependentFormatter(defaultFormatter: mockDefault);
        fakeFormatted = faker.lorem.sentence();

        when(() => mockDefault.format(any())).thenReturn(fakeFormatted);
      });

      for (final level in Level.LEVELS) {
        test('should return the default value when $level', () {
          // arrange
          final fakeRecord = LogRecord(
            level,
            faker.lorem.sentence(),
            faker.lorem.word(),
          );

          // act & assert
          expect(formatter(fakeRecord), fakeFormatted);
        });
      }
    });
  });
}
