import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:logging/logging.dart';
import 'package:logging_extensions/src/formatter/log_record_formatter.dart';
import 'package:logging_extensions/src/sink/log_sink.dart';

/// A [LogSink] which uses the [print] function to write logs to.
///
/// [formatter] is used to format [LogRecord] before printing it.
class PrintSink extends LogSink {
  PrintSink(this.formatter);

  static const lineSplitter = LineSplitter();

  /// Used to format [LogRecord] before printing it.
  final LogRecordFormatter formatter;

  @override
  Future<void> write(LogRecord logRecord) {
    final lines = lineSplitter.convert(formatter.format(logRecord));
    for (final line in lines) {
      // ignore: avoid_print
      print(line);
    }
    return Future.value();
  }
}

/// A [LogSink] which uses the [log] function to write logs to.
class DevLogSink extends LogSink {
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
