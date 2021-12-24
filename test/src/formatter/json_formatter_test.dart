import 'dart:convert';

import 'package:logging_extensions/logging_extensions.dart';
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
  });
}
