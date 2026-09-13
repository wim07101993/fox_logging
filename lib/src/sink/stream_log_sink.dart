import 'dart:async';

import 'package:fox_logging/src/filter/log_filter.dart';
import 'package:fox_logging/src/sink/log_sink.dart';
import 'package:logging/logging.dart';

/// A [LogSinkMixin] which exposes the log-records it receives as a [Stream].
class StreamLogSink with LogSinkMixin {
  /// Creates a sink which exposes its log-records as a single-subscription
  /// [stream].
  ///
  /// [filter] decides which log-records make it to the [stream]. By default
  /// none are filtered out.
  StreamLogSink([this.filter = const LogFilter.none()])
      : _controller = StreamController();

  /// Creates a sink which exposes its log-records as a broadcast [stream].
  ///
  /// [filter] decides which log-records make it to the [stream]. By default
  /// none are filtered out.
  StreamLogSink.broadcast([this.filter = const LogFilter.none()])
      : _controller = StreamController.broadcast();

  final StreamController<LogRecord> _controller;

  @override
  final LogFilter filter;

  /// The log-records written to this sink.
  Stream<LogRecord> get stream => _controller.stream;

  @override
  Future<void> write(LogRecord logRecord) {
    _controller.add(logRecord);
    return Future.value();
  }

  /// Disposes this sink and closes the [stream].
  @override
  Future<void> dispose() {
    return Future.wait([super.dispose(), _controller.close()]);
  }
}
