import 'dart:io';

import 'package:fox_logging/fox_logging.dart';

/// A [LogSinkMixin] which uses [stdout] and [stderr] to write logs to.
///
/// [formatter] is used to format [LogRecord] before printing it.
///
/// When the level is [Level.SEVERE] or higher [stderr] is used, otherwise
/// [stdout].
class IoLogSink with LogSinkMixin {
  IoLogSink(
    this.formatter, [
    this.filter = const LogFilter.none(),
  ]);

  /// Used to format [LogRecord] before printing it.
  final LogRecordFormatter formatter;

  @override
  final LogFilter filter;

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
