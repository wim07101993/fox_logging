import 'package:fox_logging/fox_logging.dart';

/// Does not filter any logs.
class NoLogFilter implements LogFilter {
  /// Creates a filter which lets every log-record through.
  const NoLogFilter();

  @override
  bool shouldLog(LogRecord logRecord) => true;
}
