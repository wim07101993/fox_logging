import 'dart:async';
import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:logging_extensions/src/parser/log_record_parser.dart';

class JsonLogRecordParser extends LogRecordParser {
  const JsonLogRecordParser();

  @override
  LogRecord parse(String value) {
    final jsonMap = jsonDecode(value) as Map<String, dynamic>;
    return _ParsedLogRecord(
      parseLevel(jsonMap['level']),
      jsonMap['message'] as String,
      jsonMap['object'],
      jsonMap['loggerName'] as String,
      DateTime.parse(jsonMap['time'] as String),
      jsonMap['sequenceNumber'] as int,
      jsonMap['error'],
      StackTrace.fromString(jsonMap['stackTrace'] as String),
    );
  }

  Level parseLevel(dynamic value) {
    if (value is Map<String, dynamic>) {
      return Level(
        value['name'] as String,
        value['value'] as int,
      );
    } else if (value is String) {
      return Level.LEVELS.firstWhere((level) => level.name == value);
    } else if (value is int) {
      return Level.LEVELS.firstWhere((level) => level.value == value);
    } else {
      return Level.FINE;
    }
  }
}

class _ParsedLogRecord implements LogRecord {
  const _ParsedLogRecord(
    this.level,
    this.message,
    this.object,
    this.loggerName,
    this.time,
    this.sequenceNumber,
    this.error,
    this.stackTrace,
  );

  @override
  final Object? error;
  @override
  final Level level;
  @override
  final String loggerName;
  @override
  final String message;
  @override
  final Object? object;
  @override
  final int sequenceNumber;
  @override
  final StackTrace? stackTrace;
  @override
  final DateTime time;
  @override
  Zone? get zone => null;
}
