import 'package:fox_logging/src/filter/log_level_filter.dart';
import 'package:fox_logging/src/filter/no_log_filter.dart';
import 'package:logging/logging.dart';

/// Filters logs before they go into the sink.
abstract class LogFilter {
  /// Creates a filter which lets every log-record through.
  const factory LogFilter.none() = NoLogFilter;

  /// Creates a filter which only lets log-records through which have at
  /// least the given [level].
  const factory LogFilter.level(Level level) = LogLevelFilter;

  /// Indicates whether [logRecord] should be logged.
  bool shouldLog(LogRecord logRecord);
}
