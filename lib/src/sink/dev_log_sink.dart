import 'dart:async';
import 'dart:developer' as developer;

import 'package:fox_logging/src/filter/log_filter.dart';
import 'package:fox_logging/src/sink/log_sink.dart';
import 'package:logging/logging.dart';

/// A [LogSinkMixin] which uses the [developer.log] function to write logs to.
class DevLogSink with LogSinkMixin {
  DevLogSink([this.filter = const LogFilter.none()]);

  @override
  final LogFilter filter;

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
