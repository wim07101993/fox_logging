import 'package:fox_logging/src/formatter/log_record_formatter.dart';
import 'package:logging/logging.dart';

/// Selects a different formatter depending on the level of the [logRecord].
class LevelDependentFormatter extends LogRecordFormatter {
  /// Constructs a new  [LevelDependentFormatter] with a formatter for each
  /// [Level].
  ///
  /// If no formatter is specified, the [defaultFormatter] is used.
  LevelDependentFormatter({
    required this.defaultFormatter,
    this.finest,
    this.finer,
    this.fine,
    this.config,
    this.info,
    this.warning,
    this.severe,
    this.shout,
    this.off,
    this.all,
  });

  /// Used when no formatter is specified for the level of the record to format.
  final LogRecordFormatter defaultFormatter;

  /// Formatter used to format records with level [Level.FINEST].
  final LogRecordFormatter? finest;

  /// Formatter used to format records with level [Level.FINER].
  final LogRecordFormatter? finer;

  /// Formatter used to format records with level [Level.FINE].
  final LogRecordFormatter? fine;

  /// Formatter used to format records with level [Level.CONFIG].
  final LogRecordFormatter? config;

  /// Formatter used to format records with level [Level.INFO].
  final LogRecordFormatter? info;

  /// Formatter used to format records with level [Level.WARNING].
  final LogRecordFormatter? warning;

  /// Formatter used to format records with level [Level.SEVERE].
  final LogRecordFormatter? severe;

  /// Formatter used to format records with level [Level.SHOUT].
  final LogRecordFormatter? shout;

  /// Formatter used to format records with level [Level.OFF].
  final LogRecordFormatter? off;

  /// Formatter used to format records with level [Level.ALL].
  final LogRecordFormatter? all;

  /// Formats the [logRecord] using the [LogRecordFormatter] specified for
  /// its [LogRecord.level].
  @override
  String format(LogRecord logRecord) {
    final formatter = switch (logRecord.level) {
      Level.FINEST => finest,
      Level.FINER => finer,
      Level.FINE => fine,
      Level.INFO => info,
      Level.CONFIG => config,
      Level.WARNING => warning,
      Level.SEVERE => severe,
      Level.SHOUT => shout,
      Level.ALL => all,
      Level.OFF => off,
      Level() => null,
    };
    return (formatter ?? defaultFormatter).format(logRecord);
  }
}
