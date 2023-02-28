import 'dart:io';

import 'package:fox_logging/fox_logging.dart';

/// A [LogSinkMixin] which uses [stdout] and [stderr] to write logs to.
///
/// [formatter] is used to format [LogRecord] before printing it.
///
/// When the level is higher than [Level.Severe] [stderr] is used, otherwise
/// [stdout].
class IoLogSink extends LogSink {
  IoLogSink(
    this.formatter, [
    super.logFilter,
  ]);

  /// Used to format [LogRecord] before printing it.
  final LogRecordFormatter formatter;

  @override
  Future<void> write(LogRecord logRecord) {
    if (logRecord.level >= Level.SEVERE) {
      stderr.writeln(formatter(logRecord));
    } else {
      stdout.writeln(formatter(logRecord));
    }
    return Future.value();
  }
}
