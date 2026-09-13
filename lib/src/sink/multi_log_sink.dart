import 'dart:async';

import 'package:fox_logging/src/sink/log_sink.dart';
import 'package:logging/logging.dart';

/// Combines multiple [LogSinkMixin] implementations into one.
class MultiLogSink extends LogSink {
  /// Creates a log-sink which writes to all given [sinks]
  MultiLogSink(this.sinks, [super.filter]);

  /// The [LogSinkMixin] implementations to write to.
  final List<LogSinkMixin> sinks;

  /// Writes [logRecord] to all [sinks].
  ///
  /// Each sink applies its own [LogSinkMixin.filter] on top of the [filter] of
  /// this sink.
  @override
  Future<void> write(LogRecord logRecord) {
    return Future.wait(sinks.map((sink) => sink.log(logRecord)));
  }

  /// Disposes this sink and all the [sinks] it writes to.
  @override
  Future<void> dispose() {
    return Future.wait([
      super.dispose(),
      ...sinks.map((sink) => sink.dispose()),
    ]);
  }
}
