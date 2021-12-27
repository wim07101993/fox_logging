import 'package:logging/logging.dart';
import 'package:logging_extensions/src/formatter/log_record_formatter.dart';

class LevelDependentFormatter extends LogRecordFormatter {
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

  final LogRecordFormatter defaultFormatter;
  final LogRecordFormatter? finest;
  final LogRecordFormatter? finer;
  final LogRecordFormatter? fine;
  final LogRecordFormatter? config;
  final LogRecordFormatter? info;
  final LogRecordFormatter? warning;
  final LogRecordFormatter? severe;
  final LogRecordFormatter? shout;
  final LogRecordFormatter? off;
  final LogRecordFormatter? all;

  @override
  String format(LogRecord logRecord) {
    LogRecordFormatter? formatter;
    if (logRecord.level == Level.FINEST) {
      formatter = finest;
    } else if (logRecord.level == Level.FINER) {
      formatter = finer;
    } else if (logRecord.level == Level.FINE) {
      formatter = fine;
    } else if (logRecord.level == Level.INFO) {
      formatter = info;
    } else if (logRecord.level == Level.CONFIG) {
      formatter = config;
    } else if (logRecord.level == Level.WARNING) {
      formatter = warning;
    } else if (logRecord.level == Level.SEVERE) {
      formatter = severe;
    } else if (logRecord.level == Level.SHOUT) {
      formatter = shout;
    } else if (logRecord.level == Level.ALL) {
      formatter = all;
    } else if (logRecord.level == Level.OFF) {
      formatter = off;
    }
    return (formatter ?? defaultFormatter).format(logRecord);
  }
}
