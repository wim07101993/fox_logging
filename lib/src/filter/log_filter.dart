import 'package:fox_logging/fox_logging.dart';

/// Filters logs before they go into the sink.
abstract class LogFilter {
  const factory LogFilter.none() = NoLogFilter;
  const factory LogFilter.level(Level level) = LogLevelFilter;

  /// Indicates whether [logRecord] should be logged.
  bool shouldLog(LogRecord logRecord);
}

/// Does not filter any logs.
class NoLogFilter implements LogFilter {
  const NoLogFilter();

  @override
  bool shouldLog(LogRecord logRecord) => true;
}

/// Only logs log-records which have at least a certain level.
class LogLevelFilter implements LogFilter {
  const LogLevelFilter(this.level);

  /// The level which the log-record must at least have.
  final Level level;

  @override
  bool shouldLog(LogRecord logRecord) => logRecord.level >= level;
}
