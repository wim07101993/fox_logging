import 'dart:convert';

import 'package:ansicolor/ansicolor.dart';
import 'package:logging/logging.dart';
import 'package:logging_extensions/src/formatter/log_record_formatter.dart';
import 'package:logging_extensions/src/level_converter/log_level_to_ansi_pen_converter.dart';
import 'package:logging_extensions/src/level_converter/log_level_to_prefix_converter.dart';

// Outputs simple log messages:
/// ```
/// [E] Log message  ERROR: Error info
/// ```
class SimpleFormatter implements LogRecordFormatter {
  SimpleFormatter({
    this.printTime = true,
    Converter<Level, AnsiPen>? toPen,
    Converter<Level, String>? toPrefix,
  })  : _toPen = toPen ?? LogLevelToAnsiPenConverter(),
        _toPrefix = toPrefix ?? LogLevelToPrefixConverter();

  final Converter<Level, AnsiPen> _toPen;
  final Converter<Level, String> _toPrefix;

  final bool printTime;

  @override
  String format(LogRecord record) {
    final level = record.level;
    final pen = _toPen.convert(level);
    final prefix = _toPrefix.convert(level);

    final colorAll = level == Level.FINEST ||
        level == Level.FINER ||
        level == Level.FINE ||
        level == Level.SEVERE ||
        level == Level.SHOUT;

    final buffer = StringBuffer(colorAll ? prefix : pen(prefix));
    if (printTime) {
      buffer.write(' ${record.time.toIso8601String()}');
    }
    if (record.loggerName.isNotEmpty) {
      buffer.write(' ${record.loggerName}:');
    }
    if (record.message.isNotEmpty) {
      buffer.write(' ${record.message}');
    }
    if (record.error != null) {
      buffer.write(' ERROR: ${record.error}');
    }

    final formattedRecord = buffer.toString();
    final retValue = colorAll ? pen(formattedRecord) : formattedRecord;
    return retValue;
  }
}
