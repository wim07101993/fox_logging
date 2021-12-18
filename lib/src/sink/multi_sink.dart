import 'dart:async';

import 'package:logging/logging.dart';
import 'package:logging_extensions/src/sink/log_sink.dart';

class MultiSink extends LogSink {
  MultiSink(this.sinks);

  final List<LogSink> sinks;

  @override
  Future<void> write(LogRecord logRecord) {
    return Future.wait(sinks.map((sink) => sink.write(logRecord)));
  }
}
