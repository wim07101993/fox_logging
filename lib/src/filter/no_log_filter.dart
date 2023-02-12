import 'package:fox_logging/fox_logging.dart';

/// Does not filter any logs.
class NoLogFilter implements LogFilter {
  const NoLogFilter();

  @override
  bool shouldLog(LogRecord logRecord) => true;
}
