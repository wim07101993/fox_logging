import 'dart:async';

import 'package:fox_logging/src/sink/log_sink.dart';
import 'package:logging/logging.dart';

class StreamLogSink extends LogSink {
  StreamLogSink() : _controller = StreamController();
  StreamLogSink.broadcast() : _controller = StreamController.broadcast();

  final StreamController<LogRecord> _controller;

  Stream<LogRecord> get stream => _controller.stream;

  @override
  Future<void> write(LogRecord logRecord) {
    _controller.add(logRecord);
    return Future.value();
  }
}
