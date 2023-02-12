import 'dart:async';

import 'package:fox_logging/src/sink/log_sink.dart';
import 'package:logging/logging.dart';

class StreamLogSink extends LogSink {
  StreamLogSink([super.logFilter]) : _controller = StreamController();
  StreamLogSink.broadcast([super.logFilter])
      : _controller = StreamController.broadcast();

  final StreamController<LogRecord> _controller;

  Stream<LogRecord> get stream => _controller.stream;

  @override
  Future<void> write(LogRecord logRecord) {
    _controller.add(logRecord);
    return Future.value();
  }
}
