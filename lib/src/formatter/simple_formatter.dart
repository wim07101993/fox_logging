import 'dart:convert';

import 'package:ansicolor/ansicolor.dart';
import 'package:fox_logging/src/formatter/log_record_formatter.dart';
import 'package:fox_logging/src/level_converter/log_level_to_abbreviation.dart';
import 'package:fox_logging/src/level_converter/log_level_to_ansi_pen_converter.dart';
import 'package:logging/logging.dart';

/// Formats as [LogRecord] in a simple, concise way.
///
/// Formatted example:
/// ```
/// [E] 2021-12-26T13:36:03.012282 Simple: Type error ... ERROR: Throw of Something.
/// ```
class SimpleFormatter extends LogRecordFormatter {
  /// Constructs a new [SimpleFormatter].
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
  SimpleFormatter({
    this.printTime = true,
    Converter<Level, AnsiPen>? levelToPen,
    Converter<Level, String>? levelToPrefix,
  })  : levelToPen = levelToPen ?? LogLevelToAnsiPenConverter(),
        levelToPrefix = levelToPrefix ?? LogLevelToAbbreviationConverter();

  /// Converter used to select the correct [AnsiPen] to write ansi-colors in
  /// the formatted log.
  final Converter<Level, AnsiPen> levelToPen;

  /// Converter used to create the symbol in the top left corner of the log to
  /// indicate what level the log is.
  final Converter<Level, String> levelToPrefix;

  /// Indicates whether the time should be visible on the logs.
  final bool printTime;

  @override
  String format(LogRecord record) {
    final level = record.level;
    final pen = levelToPen.convert(level);
    final prefix = levelToPrefix.convert(level);

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
