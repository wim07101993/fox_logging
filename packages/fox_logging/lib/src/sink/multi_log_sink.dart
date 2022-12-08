import 'dart:async';

import 'package:fox_logging/src/sink/log_sink.dart';
import 'package:logging/logging.dart';

/// Combines multiple [LogSink] implementations into one.
class MultiLogSink extends LogSink {
  /// Creates a log-sink which writes to all given [sinks]
  MultiLogSink(this.sinks);

  /// The [LogSink] implementations to write to.
  final List<LogSink> sinks;

  /// Writes [logRecord] to all [sinks].
  @override
  Future<void> write(LogRecord logRecord) {
    return Future.wait(sinks.map((sink) => sink.write(logRecord)));
  }
}
