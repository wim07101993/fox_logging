import 'package:fox_logging/src/filter/log_level_filter.dart';
import 'package:fox_logging/src/filter/no_log_filter.dart';
import 'package:logging/logging.dart';

/// Filters logs before they go into the sink.
abstract class LogFilter {
  const factory LogFilter.none() = NoLogFilter;
  const factory LogFilter.level(Level level) = LogLevelFilter;

  /// Indicates whether [logRecord] should be logged.
  bool shouldLog(LogRecord logRecord);
}
