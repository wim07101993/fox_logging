import 'dart:convert';

import 'package:ansicolor/ansicolor.dart';
import 'package:fox_logging/src/formatter/log_record_formatter.dart';
import 'package:fox_logging/src/helping_extensions.dart';
import 'package:fox_logging/src/level_converter/log_level_to_ansi_pen_converter.dart';
import 'package:fox_logging/src/level_converter/log_level_to_symbol_converter.dart';
import 'package:logging/logging.dart';

/// Formats a [LogRecord] to a pretty, human readable [String].
///
/// Formatted example:
/// ```
/// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/// ┃ ⛔  Null reference exception ...
/// ┃ Error: Throw of null.
/// ┠───────────────────────────────────────────────────────────────────────────────
/// ┃ Time: 2021-12-26T13:36:03.017444 │ Logger: Pretty
/// ┠───────────────────────────────────────────────────────────────────────────────
/// ┃ #0      main (file:///home/wim/source/repos/fox_logging/example/main.dart:38:16)
/// ┃ #1      _delayEntrypointInvocation.<anonymous closure> (dart:isolate-patch/isolate_patch.dart:297:19)
/// ┃ #2      _RawReceivePortImpl._handleMessage (dart:isolate-patch/isolate_patch.dart:192:12)
/// ┃
/// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/// ```
///
/// If the level is [Level.SEVERE] or [Level.SHOUT], the borders are bold.
class PrettyFormatter extends LogRecordFormatter {
  /// Constructs a new [PrettyFormatter].
  ///
  /// - [printTime]: indicates whether the time should be visible on the logs
  ///
  /// - [levelToPen]: converter used to select the correct [AnsiPen] to write
  /// ansi-colors in the formatted log. If none is provided, the
  /// [LogLevelToAnsiPenConverter] is used.
  ///
  /// - [levelToSymbol]: converter used to create the symbol in the top left
  /// corner of the log to indicate what level the log is. If none is provided,
  /// the [LogLevelToSymbolConverter] is used.
  PrettyFormatter({
    this.printTime = true,
    Converter<Level, AnsiPen>? levelToPen,
    Converter<Level, String>? levelToSymbol,
  })  : levelToPen = levelToPen ?? LogLevelToAnsiPenConverter(),
        levelToSymbol = levelToSymbol ?? LogLevelToSymbolConverter();

  /// Converter used to select the correct [AnsiPen] to write ansi-colors in
  /// the formatted log.
  final Converter<Level, AnsiPen> levelToPen;

  /// Converter used to create the symbol in the top left corner of the log to
  /// indicate what level the log is.
  final Converter<Level, String> levelToSymbol;

  /// Indicates whether the time should be visible on the logs.
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
