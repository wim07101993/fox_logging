import 'dart:async';
import 'dart:convert';

import 'package:fox_logging/src/filter/log_filter.dart';
import 'package:fox_logging/src/formatter/log_record_formatter.dart';
import 'package:fox_logging/src/sink/log_sink.dart';
import 'package:logging/logging.dart';

/// A [LogSinkMixin] which uses the [print] function to write logs to.
///
/// [formatter] is used to format [LogRecord] before printing it.
class PrintSink with LogSinkMixin {
  /// Creates a sink which writes its log-records with [print].
  ///
  /// [formatter] is used to format a [LogRecord] before printing it.
  /// [filter] decides which log-records get printed. By default none are
  /// filtered out.
  PrintSink(
    this.formatter, [
    this.filter = const LogFilter.none(),
  ]);

  /// Splits a formatted log-record into the lines which are printed
  /// separately.
  static const lineSplitter = LineSplitter();

  /// Used to format [LogRecord] before printing it.
  final LogRecordFormatter formatter;

  @override
  final LogFilter filter;

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
