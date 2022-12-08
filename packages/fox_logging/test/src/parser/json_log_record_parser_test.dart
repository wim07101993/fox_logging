import 'dart:convert';

import 'package:fox_logging/fox_logging.dart';
import 'package:test/test.dart';

import '../../faker_extensions.dart';

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
    });
  });
}
