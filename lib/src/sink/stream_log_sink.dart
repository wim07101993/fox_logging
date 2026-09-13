import 'dart:async';

import 'package:fox_logging/src/sink/log_sink.dart';
import 'package:logging/logging.dart';

/// A [LogSinkMixin] which exposes the log-records it receives as a [Stream].
class StreamLogSink extends LogSink {
  /// Creates a sink which exposes its log-records as a single-subscription
  /// [stream].
  ///
  /// [filter] decides which log-records make it to the [stream]. By default
  /// none are filtered out.
  StreamLogSink([super.filter]) : _controller = StreamController();

  /// Creates a sink which exposes its log-records as a broadcast [stream].
  ///
  /// [filter] decides which log-records make it to the [stream]. By default
  /// none are filtered out.
  StreamLogSink.broadcast([super.filter])
      : _controller = StreamController.broadcast();

  final StreamController<LogRecord> _controller;

  /// The log-records written to this sink.
  Stream<LogRecord> get stream => _controller.stream;

  @override
  Future<void> write(LogRecord logRecord) {
    _controller.add(logRecord);
    return Future.value();
  }

  /// Disposes this sink and closes the [stream].
  ///
  /// Does not wait for the done event to reach a listener. A
  /// single-subscription stream only delivers that event once something
  /// listens to it, so waiting would hang the disposal of a sink which was
  /// never listened to, or whose listener is paused.
  @override
  Future<void> dispose() async {
    await super.dispose();
    unawaited(_controller.close());
  }
}
