import 'dart:async';
import 'dart:convert';

import 'package:fox_logging/src/parser/log_record_parser.dart';
import 'package:logging/logging.dart';

/// Deserializes a json-encoded [LogRecord].
///
/// Valid input example:
/// ```
/// {"level":{"value":1000,"name":"SEVERE"},"message":"Hello world","object":{"Name":"John","Age":42},"loggerName":"PrettyLogger","time":"2021-12-26T13:34:39.700","sequenceNumber":2,"error":"Something went wrong while fetching profile","stackTrace":"Error\n    at Object.StackTrace_current (<anonymous>:2671:40)\n    at main (<anonymous>:2824:501)\n    at <anonymous>:3896:7\n    at <anonymous>:3879:7\n    at dartProgram (<anonymous>:3890:5)\n    at <anonymous>:3898:3\n    at replaceJavaScript (https://dartpad.dev/scripts/frame.js:19:19)\n    at messageHandler (https://dartpad.dev/scripts/frame.js:140:13)"}
/// ```
class JsonLogRecordParser extends LogRecordParser {
  /// Constructs a new [JsonLogRecordParser].
  const JsonLogRecordParser();

  /// Deserializes a json encoded [LogRecord].
  ///
  /// Uses the [jsonDecode] method.
  @override
  LogRecord parse(String value) {
    final jsonMap = jsonDecode(value) as Map<String, dynamic>;
    return parseMap(jsonMap);
  }

  /// Parses a [Map] to a [LogRecord]
  LogRecord parseMap(Map<String, dynamic> map) {
    final stackTraceStr = map['stackTrace'];
    return _ParsedLogRecord(
      parseLevel(map['level']),
      map['message'] as String,
      map['object'],
      map['loggerName'] as String,
      DateTime.parse(map['time'] as String),
      map['sequenceNumber'] as int,
      map['error'],
      stackTraceStr is! String ? null : StackTrace.fromString(stackTraceStr),
    );
  }

  /// Parses [value] to [Level].
  ///
  /// - If [value] is a [Map<String, dynamic>], the name and value fields are
  /// retrieved from the map.
  /// - If [value] is a [String] the [Level] with [value] as its name is used.
  /// - If [value] is an [int] the [Level] with [value] as its value is used.
  ///
  /// If none of the above match, [Level.FINE] is returned.
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

  /// Deserializes a json encoded [List] of [LogRecord].
  @override
  Iterable<LogRecord> parseList(String value) sync* {
    final list = jsonDecode(value) as List;
    for (final item in list) {
      yield parseMap(item as Map<String, dynamic>);
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
