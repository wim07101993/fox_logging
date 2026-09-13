import 'package:fox_logging/src/filter/log_filter.dart';
import 'package:logging/logging.dart';

/// Only logs log-records which have at least a certain level.
class LogLevelFilter implements LogFilter {
  /// Creates a filter which only lets log-records through which have at
  /// least the given [level].
  const LogLevelFilter(this.level);

  /// The level which the log-record must at least have.
  final Level level;

  @override
  bool shouldLog(LogRecord logRecord) => logRecord.level >= level;
}
