import 'dart:async';
import 'dart:developer';

import 'package:fox_logging/src/sink/log_sink.dart';
import 'package:logging/logging.dart';

/// A [LogSinkMixin] which uses the [log] function to write logs to.
class DevLogSink extends LogSink {
  DevLogSink([super.logFilter]);

  @override
  Future<void> write(LogRecord logRecord) {
    log(
      logRecord.message,
      time: logRecord.time,
      sequenceNumber: logRecord.sequenceNumber,
      level: logRecord.level.value,
      name: logRecord.loggerName,
      error: logRecord.error,
      stackTrace: logRecord.stackTrace,
    );
    return Future.value();
  }
}
