import 'dart:async';
import 'dart:developer';

import 'package:logging/logging.dart';
import 'package:logging_extensions/src/formatter/log_record_formatter.dart';
import 'package:logging_extensions/src/sinks/log_sink.dart';

class PrintSink extends LogSink {
  PrintSink(this.formatter);

  final LogRecordFormatter formatter;

  @override
  Future<void> write(LogRecord logRecord) {
    // ignore: avoid_print
    print(formatter.format(logRecord));
    return Future.value();
  }
}

class DevLogSink extends LogSink {
  DevLogSink(this.formatter);

  final LogRecordFormatter formatter;

  @override
  Future<void> write(LogRecord logRecord) {
    log(formatter.format(logRecord));
    return Future.value();
  }
}
