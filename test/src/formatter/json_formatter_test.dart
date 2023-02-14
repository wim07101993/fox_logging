import 'dart:convert';

import 'package:fox_logging/fox_logging.dart';
import 'package:test/test.dart';

import '../../faker_extensions.dart';

void main() {
  late JsonFormatter jsonFormatter;

  setUp(() {
    jsonFormatter = const JsonFormatter();
  });

  group('format', () {
    test('should format a complete log-record', () {
      // arrange
      final logRecord = LogRecord(
        faker.logLevel(),
        faker.lorem.sentence(),
        faker.lorem.word(),
        faker.lorem.sentence(),
        StackTrace.current,
        null,
        faker.lorem.sentence(),
      );

      // act
      final json = jsonFormatter.format(logRecord);

      // assert
      expect(
        json,
        jsonEncode({
          'level': {
            'value': logRecord.level.value,
            'name': logRecord.level.name,
          },
          'message': logRecord.message,
          'object': logRecord.object! as String,
          'loggerName': logRecord.loggerName,
          'time': logRecord.time.toIso8601String(),
          'sequenceNumber': logRecord.sequenceNumber,
          'error': logRecord.error! as String,
          'stackTrace': logRecord.stackTrace!.toString(),
        }),
      );
    });

    test('should leave object out if null', () {
      // arrange
      final logRecord = LogRecord(
        faker.logLevel(),
        faker.lorem.sentence(),
        faker.lorem.word(),
        faker.lorem.sentence(),
        StackTrace.current,
      );

      // act
      final json = jsonFormatter.format(logRecord);

      // assert
      expect(
        json,
        jsonEncode({
          'level': {
            'value': logRecord.level.value,
            'name': logRecord.level.name,
          },
          'message': logRecord.message,
          'loggerName': logRecord.loggerName,
          'time': logRecord.time.toIso8601String(),
          'sequenceNumber': logRecord.sequenceNumber,
          'error': logRecord.error! as String,
          'stackTrace': logRecord.stackTrace!.toString(),
        }),
      );
    });

    test('should leave error out if null', () {
      // arrange
      final logRecord = LogRecord(
        faker.logLevel(),
        faker.lorem.sentence(),
        faker.lorem.word(),
        null,
        StackTrace.current,
        null,
        faker.lorem.sentence(),
      );

      // act
      final json = jsonFormatter.format(logRecord);

      // assert
      expect(
        json,
        jsonEncode({
          'level': {
            'value': logRecord.level.value,
            'name': logRecord.level.name,
          },
          'message': logRecord.message,
          'object': logRecord.object! as String,
          'loggerName': logRecord.loggerName,
          'time': logRecord.time.toIso8601String(),
          'sequenceNumber': logRecord.sequenceNumber,
          'stackTrace': logRecord.stackTrace!.toString(),
        }),
      );
    });

    test('should leave stackTrace out if null', () {
      // arrange
      final logRecord = LogRecord(
        faker.logLevel(),
        faker.lorem.sentence(),
        faker.lorem.word(),
        faker.lorem.sentence(),
        null,
        null,
        faker.lorem.sentence(),
      );

      // act
      final json = jsonFormatter.format(logRecord);

      // assert
      expect(
        json,
        jsonEncode({
          'level': {
            'value': logRecord.level.value,
            'name': logRecord.level.name,
          },
          'message': logRecord.message,
          'object': logRecord.object! as String,
          'loggerName': logRecord.loggerName,
          'time': logRecord.time.toIso8601String(),
          'sequenceNumber': logRecord.sequenceNumber,
          'error': logRecord.error! as String,
        }),
      );
    });

    test('should format object to string', () {
      // arrange
      final logRecord = LogRecord(
        faker.logLevel(),
        faker.lorem.sentence(),
        faker.lorem.word(),
        null,
        null,
        null,
        TypeError(),
      );

      // act
      final json = jsonFormatter.format(logRecord);

      // assert
      expect(
        json,
        jsonEncode({
          'level': {
            'value': logRecord.level.value,
            'name': logRecord.level.name,
          },
          'message': logRecord.message,
          'object': logRecord.object!.toString(),
          'loggerName': logRecord.loggerName,
          'time': logRecord.time.toIso8601String(),
          'sequenceNumber': logRecord.sequenceNumber,
        }),
      );
    });

    test('should format error to string', () {
      // arrange
      final logRecord = LogRecord(
        faker.logLevel(),
        faker.lorem.sentence(),
        faker.lorem.word(),
        TypeError(),
      );

      // act
      final json = jsonFormatter.format(logRecord);

      // assert
      expect(
        json,
        jsonEncode({
          'level': {
            'value': logRecord.level.value,
            'name': logRecord.level.name,
          },
          'message': logRecord.message,
          'loggerName': logRecord.loggerName,
          'time': logRecord.time.toIso8601String(),
          'sequenceNumber': logRecord.sequenceNumber,
          'error': logRecord.error!.toString(),
        }),
      );
    });
  });

  group('formatList', () {
    test('should convert the list to a json array', () {
      // arrange
      final logRecord1 = faker.logRecord(
        generateError: false,
        generateObject: false,
        generateStackTrace: false,
      );
      final logRecord2 = faker.logRecord(
        generateError: false,
        generateObject: false,
        generateStackTrace: false,
      );
      final logRecord3 = faker.logRecord(
        generateError: false,
        generateObject: false,
        generateStackTrace: false,
      );

      // act
      final json = jsonFormatter.formatList([
        logRecord1,
        logRecord2,
        logRecord3,
      ]);

      // assert
      expect(
        json,
        jsonEncode(
          [
            {
              'level': {
                'value': logRecord1.level.value,
                'name': logRecord1.level.name,
              },
              'message': logRecord1.message,
              'loggerName': logRecord1.loggerName,
              'time': logRecord1.time.toIso8601String(),
              'sequenceNumber': logRecord1.sequenceNumber,
            },
            {
              'level': {
                'value': logRecord2.level.value,
                'name': logRecord2.level.name,
              },
              'message': logRecord2.message,
              'loggerName': logRecord2.loggerName,
              'time': logRecord2.time.toIso8601String(),
              'sequenceNumber': logRecord2.sequenceNumber,
            },
            {
              'level': {
                'value': logRecord3.level.value,
                'name': logRecord3.level.name,
              },
              'message': logRecord3.message,
              'loggerName': logRecord3.loggerName,
              'time': logRecord3.time.toIso8601String(),
              'sequenceNumber': logRecord3.sequenceNumber,
            },
          ],
        ),
      );
    });
  });
}
