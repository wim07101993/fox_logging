import 'dart:async';
import 'dart:convert';

import 'package:fox_logging/src/formatter/log_record_formatter.dart';
import 'package:fox_logging/src/sink/log_sink.dart';
import 'package:logging/logging.dart';

/// A [LogSinkMixin] which uses the [print] function to write logs to.
///
/// [formatter] is used to format [LogRecord] before printing it.
class PrintSink extends LogSink {
  PrintSink(
    this.formatter, [
    super.logFilter,
  ]);

  static const lineSplitter = LineSplitter();

  /// Used to format [LogRecord] before printing it.
  final LogRecordFormatter formatter;

  @override
  Future<void> write(LogRecord logRecord) {
    final lines = lineSplitter.convert(formatter.format(logRecord));
    for (final line in lines) {
      // ignore: avoid_print
      print(line);
    }
    return Future.value();
  }
}
