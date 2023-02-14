import 'dart:convert';

import 'package:fox_logging/src/formatter/log_record_formatter.dart';
import 'package:logging/logging.dart';

/// Serializes a [LogRecord] to json.
///
/// Formatted example:
/// ```
/// {"level":{"value":1000,"name":"SEVERE"},"message":"Hello world","object":{"Name":"John","Age":42},"loggerName":"PrettyLogger","time":"2021-12-26T13:34:39.700","sequenceNumber":2,"error":"Something went wrong while fetching profile","stackTrace":"Error\n    at Object.StackTrace_current (<anonymous>:2671:40)\n    at main (<anonymous>:2824:501)\n    at <anonymous>:3896:7\n    at <anonymous>:3879:7\n    at dartProgram (<anonymous>:3890:5)\n    at <anonymous>:3898:3\n    at replaceJavaScript (https://dartpad.dev/scripts/frame.js:19:19)\n    at messageHandler (https://dartpad.dev/scripts/frame.js:140:13)"}
/// ```
class JsonFormatter extends LogRecordFormatter {
  /// Constructs a new instance of a [JsonFormatter].
  const JsonFormatter();

  /// Formats a [LogRecord] to a json-[String].
  ///
  /// The serialization is done using the [jsonEncode] function. Make sure the
  /// object and error fields of [logRecord] can be encoded with this function.
  @override
  String format(LogRecord logRecord) {
    return jsonEncode(_logRecordToJsonMap(logRecord));
  }

  @override
  String formatList(List<LogRecord> list) {
    return jsonEncode(list.map(_logRecordToJsonMap).toList(growable: false));
  }

  Map<String, dynamic> _logRecordToJsonMap(LogRecord logRecord) {
    final object = logRecord.object;
    final error = logRecord.error;

    final stackTrace = logRecord.stackTrace;

    return {
      'level': {
        'value': logRecord.level.value,
        'name': logRecord.level.name,
      },
      'message': logRecord.message,
      if (object != null) 'object': object.toString(),
      'loggerName': logRecord.loggerName,
      'time': logRecord.time.toIso8601String(),
      'sequenceNumber': logRecord.sequenceNumber,
      if (error != null) 'error': error.toString(),
      if (stackTrace != null) 'stackTrace': stackTrace.toString(),
    };
  }
}
