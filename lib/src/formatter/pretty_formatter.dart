import 'dart:convert';

import 'package:ansicolor/ansicolor.dart';
import 'package:logging/logging.dart';
import 'package:logging_extensions/src/formatter/log_record_formatter.dart';
import 'package:logging_extensions/src/helping_extensions.dart';
import 'package:logging_extensions/src/level_converter/log_level_to_ansi_pen_converter.dart';
import 'package:logging_extensions/src/level_converter/log_level_to_symbol_converter.dart';

class PrettyFormatter implements LogRecordFormatter {
  PrettyFormatter({
    this.printTime = true,
    Converter<Level, AnsiPen>? levelToPen,
    Converter<Level, String>? levelToSymbol,
  })  : levelToPen = levelToPen ?? LogLevelToAnsiPenConverter(),
        levelToSymbol = levelToSymbol ?? LogLevelToSymbolConverter();

  final Converter<Level, AnsiPen> levelToPen;
  final Converter<Level, String> levelToSymbol;

  final bool printTime;

  @override
  String format(LogRecord record) {
    final level = record.level;
    final symbol = levelToSymbol.convert(level);
    return level != Level.SEVERE && level != Level.SHOUT
        ? _format(record, symbol)
        : _format(
            record,
            symbol,
            horizontalOuterBorder: '━',
            horizontalInner: '─',
            verticalOuterBorder: '┃',
            topLeftCorner: '┏',
            leftSplit: '┠',
            bottomLeftCorner: '┗',
          );
  }

  String _format(
    LogRecord record,
    String symbol, {
    String horizontalOuterBorder = '─',
    String horizontalInner = '┄',
    String verticalOuterBorder = '│',
    String topLeftCorner = '┌',
    String leftSplit = '├',
    String bottomLeftCorner = '└',
  }) {
    final level = record.level;
    final buffer = StringBuffer();

    buffer.writeln(topLeftCorner.padRight(80, horizontalOuterBorder));
    _writeLinesToBuffer(
      buffer,
      verticalOuterBorder,
      '$symbol  ${record.message}',
    );

    final object = record.object;
    if (object != null) {
      buffer.writeln('$verticalOuterBorder Payload: ${object.toString()}');
    }
    final error = record.error;
    if (error != null) {
      buffer.writeln('$verticalOuterBorder Error: ${error.toString()}');
    }

    final loggerName = record.loggerName;
    if (printTime || loggerName.isNotEmpty) {
      buffer.writeln(leftSplit.padRight(80, horizontalInner));
      buffer.write('$verticalOuterBorder ');
      if (printTime) {
        buffer.write('Time: ${record.time.toIso8601String()}');
      }
      if (loggerName.isNotEmpty) {
        if (printTime) {
          buffer.write(' │ ');
        }
        buffer.write('Logger: $loggerName');
      }
      buffer.writeln();
    }

    final stackTrace = record.stackTrace;
    if (stackTrace != null) {
      buffer.writeln(leftSplit.padRight(80, horizontalInner));
      _writeLinesToBuffer(buffer, verticalOuterBorder, stackTrace.toString());
    }

    buffer.write(bottomLeftCorner.padRight(80, horizontalOuterBorder));

    return levelToPen.convert(level)(buffer.toString());
  }

  void _writeLinesToBuffer(
    StringBuffer buffer,
    String vertical,
    String message,
  ) {
    for (final part in message.split('\r').mapMany((e) => e.split('\n'))) {
      buffer.writeln('$vertical $part');
    }
  }
}
