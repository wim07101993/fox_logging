import 'dart:async';
import 'dart:developer' as developer;

import 'package:fox_logging/src/sink/log_sink.dart';
import 'package:logging/logging.dart';

/// A [LogSinkMixin] which uses the [developer.log] function to write logs to.
class DevLogSink extends LogSink {
  /// Creates a sink which writes its log-records with [developer.log].
  ///
  /// [filter] decides which log-records make it to [developer.log]. By
  /// default none are filtered out.
  DevLogSink([super.filter]);

  @override
  Future<void> write(LogRecord logRecord) {
    developer.log(
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
