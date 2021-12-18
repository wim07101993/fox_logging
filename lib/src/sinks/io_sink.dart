import 'dart:async';
import 'dart:io';

import 'package:logging/logging.dart';
import 'package:logging_extensions/src/formatter/log_record_formatter.dart';
import 'package:logging_extensions/src/sinks/log_sink.dart';

class IOLogSink extends LogSink {
  IOLogSink({
    required this.sink,
    required this.formatter,
  });

  final IOSink sink;
  final LogRecordFormatter formatter;

  @override
  Future<void> write(LogRecord logRecord) {
    final formatted = formatter.format(logRecord);
    sink.writeln(formatted);
    return sink.flush();
  }

  @override
  Future<void> dispose() async {
    await sink.flush();
    return super.dispose();
  }
}
