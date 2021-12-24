import 'package:logging/logging.dart';

abstract class LogRecordFormatter {
  const LogRecordFormatter();

  String call(LogRecord logRecord) => format(logRecord);
  String format(LogRecord logRecord);
}
