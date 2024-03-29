import 'dart:convert';

import 'package:fox_logging/fox_logging.dart';
import 'package:test/test.dart';

import '../../faker_extensions.dart';
import '../../log_record_matcher.dart';

void main() {
  late JsonLogRecordParser parser;

  setUp(() {
    parser = const JsonLogRecordParser();
  });

  group('parse', () {
    test('should parse a log record', () {
      // arrange
      final fakeLogRecord = LogRecord(
        faker.logLevel(),
        faker.lorem.sentence(),
        faker.lorem.word(),
        faker.lorem.sentence(),
        StackTrace.current,
        null,
        faker.lorem.sentence(),
      );
      final fakeJson = '''
      {
  "level": {
    "name": "${fakeLogRecord.level.name}",
    "value": ${fakeLogRecord.level.value}
  },
  "message": "${fakeLogRecord.message}",
  "object": "${fakeLogRecord.object}",
  "loggerName": "${fakeLogRecord.loggerName}",
  "time": "${fakeLogRecord.time.toIso8601String()}",
  "sequenceNumber": ${fakeLogRecord.sequenceNumber},
  "error": "${fakeLogRecord.error}",
  "stackTrace": ${jsonEncode(fakeLogRecord.stackTrace.toString())}
}
''';

      // act
      final logRecord = parser(fakeJson);

      // assert
      expect(logRecord.level, fakeLogRecord.level);
      expect(logRecord.message, fakeLogRecord.message);
      expect(logRecord.object, fakeLogRecord.object);
      expect(logRecord.loggerName, fakeLogRecord.loggerName);
      expect(logRecord.time, fakeLogRecord.time);
      expect(logRecord.sequenceNumber, fakeLogRecord.sequenceNumber);
      expect(logRecord.error, fakeLogRecord.error);
      expect(
        logRecord.stackTrace.toString(),
        fakeLogRecord.stackTrace.toString(),
      );
      expect(logRecord.zone, isNull);
    });
  });

  group('parseMap', () {
    test('should parse a map to a log record', () {
      // arrange
      final fakeLogRecord = LogRecord(
        faker.logLevel(),
        faker.lorem.sentence(),
        faker.lorem.word(),
        faker.lorem.sentence(),
        StackTrace.current,
        null,
        faker.lorem.sentence(),
      );
      final fakeMap = <String, dynamic>{
        "level": <String, dynamic>{
          "name": fakeLogRecord.level.name,
          "value": fakeLogRecord.level.value,
        },
        "message": fakeLogRecord.message,
        "object": fakeLogRecord.object,
        "loggerName": fakeLogRecord.loggerName,
        "time": fakeLogRecord.time.toIso8601String(),
        "sequenceNumber": fakeLogRecord.sequenceNumber,
        "error": fakeLogRecord.error,
        "stackTrace": fakeLogRecord.stackTrace.toString(),
      };

      // act
      final logRecord = parser.parseMap(fakeMap);

      // assert
      expect(logRecord.level, fakeLogRecord.level);
      expect(logRecord.message, fakeLogRecord.message);
      expect(logRecord.object, fakeLogRecord.object);
      expect(logRecord.loggerName, fakeLogRecord.loggerName);
      expect(logRecord.time, fakeLogRecord.time);
      expect(logRecord.sequenceNumber, fakeLogRecord.sequenceNumber);
      expect(logRecord.error, fakeLogRecord.error);
      expect(
        logRecord.stackTrace.toString(),
        fakeLogRecord.stackTrace.toString(),
      );
    });

    test('stack-trace should be null when it is null in the map', () {
      // arrange
      final fakeLogRecord = LogRecord(
        faker.logLevel(),
        faker.lorem.sentence(),
        faker.lorem.word(),
        faker.lorem.sentence(),
        null,
        null,
        faker.lorem.sentence(),
      );
      final fakeMap = <String, dynamic>{
        "level": <String, dynamic>{
          "name": fakeLogRecord.level.name,
          "value": fakeLogRecord.level.value,
        },
        "message": fakeLogRecord.message,
        "object": fakeLogRecord.object,
        "loggerName": fakeLogRecord.loggerName,
        "time": fakeLogRecord.time.toIso8601String(),
        "sequenceNumber": fakeLogRecord.sequenceNumber,
        "error": fakeLogRecord.error,
        "stackTrace": faker.randomGenerator.integer(100),
      };

      // act
      final logRecord = parser.parseMap(fakeMap);

      // assert
      expect(logRecord.level, fakeLogRecord.level);
      expect(logRecord.message, fakeLogRecord.message);
      expect(logRecord.object, fakeLogRecord.object);
      expect(logRecord.loggerName, fakeLogRecord.loggerName);
      expect(logRecord.time, fakeLogRecord.time);
      expect(logRecord.sequenceNumber, fakeLogRecord.sequenceNumber);
      expect(logRecord.error, fakeLogRecord.error);
      expect(logRecord.stackTrace, isNull);
    });

    test('stack-trace should be null when it is not a string in the map', () {
      // arrange
      final fakeLogRecord = LogRecord(
        faker.logLevel(),
        faker.lorem.sentence(),
        faker.lorem.word(),
        faker.lorem.sentence(),
        null,
        null,
        faker.lorem.sentence(),
      );
      final fakeMap = <String, dynamic>{
        "level": <String, dynamic>{
          "name": fakeLogRecord.level.name,
          "value": fakeLogRecord.level.value,
        },
        "message": fakeLogRecord.message,
        "object": fakeLogRecord.object,
        "loggerName": fakeLogRecord.loggerName,
        "time": fakeLogRecord.time.toIso8601String(),
        "sequenceNumber": fakeLogRecord.sequenceNumber,
        "error": fakeLogRecord.error,
      };

      // act
      final logRecord = parser.parseMap(fakeMap);

      // assert
      expect(logRecord.level, fakeLogRecord.level);
      expect(logRecord.message, fakeLogRecord.message);
      expect(logRecord.object, fakeLogRecord.object);
      expect(logRecord.loggerName, fakeLogRecord.loggerName);
      expect(logRecord.time, fakeLogRecord.time);
      expect(logRecord.sequenceNumber, fakeLogRecord.sequenceNumber);
      expect(logRecord.error, fakeLogRecord.error);
      expect(logRecord.stackTrace, isNull);
    });
  });

  group('parseLevel', () {
    test('should parse a map', () {
      // arrange
      final name = faker.lorem.word();
      final value = faker.randomGenerator.integer(100);
      final map = {
        'name': name,
        'value': value,
      };

      // act
      final level = parser.parseLevel(map);

      // assert
      expect(level.name, name);
      expect(level.value, value);
    });

    test('should parse a string', () {
      // arrange
      final original = faker.randomGenerator.element(Level.LEVELS);

      // act
      final level = parser.parseLevel(original.name);

      // assert
      expect(level.name, original.name);
      expect(level.value, original.value);
    });

    test('should parse an int', () {
      // arrange
      final original = faker.randomGenerator.element(Level.LEVELS);

      // act
      final level = parser.parseLevel(original.value);

      // assert
      expect(level.name, original.name);
      expect(level.value, original.value);
    });

    test('should return fine for everything else', () {
      // act
      final level = parser.parseLevel(faker);

      // assert
      expect(level.name, Level.FINE.name);
      expect(level.value, Level.FINE.value);
    });
  });

  group('parseList', () {
    test('should parse a list of log records', () {
      // arrange
      final fakeLogRecord = LogRecord(
        faker.logLevel(),
        faker.lorem.sentence(),
        faker.lorem.word(),
        faker.lorem.sentence(),
        StackTrace.current,
        null,
        faker.lorem.sentence(),
      );
      final fakeJson = '''
[
  {
    "level": {
      "name": "${fakeLogRecord.level.name}",
      "value": ${fakeLogRecord.level.value}
    },
    "message": "${fakeLogRecord.message}",
    "object": "${fakeLogRecord.object}",
    "loggerName": "${fakeLogRecord.loggerName}",
    "time": "${fakeLogRecord.time.toIso8601String()}",
    "sequenceNumber": ${fakeLogRecord.sequenceNumber},
    "error": "${fakeLogRecord.error}",
    "stackTrace": ${jsonEncode(fakeLogRecord.stackTrace.toString())}
  }
]
''';

      // act
      final logRecord = parser.parseList(fakeJson).toList()[0];

      // assert
      expect(logRecord.level, fakeLogRecord.level);
      expect(logRecord.message, fakeLogRecord.message);
      expect(logRecord.object, fakeLogRecord.object);
      expect(logRecord.loggerName, fakeLogRecord.loggerName);
      expect(logRecord.time, fakeLogRecord.time);
      expect(logRecord.sequenceNumber, fakeLogRecord.sequenceNumber);
      expect(logRecord.error, fakeLogRecord.error);
      expect(
        logRecord.stackTrace.toString(),
        fakeLogRecord.stackTrace.toString(),
      );
    });

    test('should parse output from [JsonFormatter]', () {
      // arrange
      final logRecord1 = faker.logRecord();
      final logRecord2 = faker.logRecord();
      final logRecord3 = faker.logRecord();
      final json = const JsonFormatter().formatList([
        logRecord1,
        logRecord2,
        logRecord3,
      ]);

      // act
      final logRecords = parser.parseList(json);

      // assert
      expect(logRecords, contains(equalsLogRecord(logRecord1)));
      expect(logRecords, contains(equalsLogRecord(logRecord2)));
      expect(logRecords, contains(equalsLogRecord(logRecord3)));
    });
  });
}
