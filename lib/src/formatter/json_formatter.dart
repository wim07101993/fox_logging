import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:logging_extensions/logging_extensions.dart';

class JsonFormatter extends LogRecordFormatter {
  const JsonFormatter();

  @override
  String format(LogRecord logRecord) {
    return jsonEncode(_logRecordToJsonMap(logRecord));
  }

  Map<String, dynamic> _logRecordToJsonMap(LogRecord logRecord) {
    final strObject = logRecord.object;
    final strError = logRecord.error;

    final stackTrace = logRecord.stackTrace;

    return {
      'level': {
        'value': logRecord.level.value,
        'name': logRecord.level.name,
      },
      'message': logRecord.message,
      if (strObject != null) 'object': strObject,
      'loggerName': logRecord.loggerName,
      'time': logRecord.time.toIso8601String(),
      'sequenceNumber': logRecord.sequenceNumber,
      if (strError != null) 'error': strError,
      if (stackTrace != null) 'stackTrace': stackTrace.toString(),
    };
  }
}
