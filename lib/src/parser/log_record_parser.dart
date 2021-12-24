import 'package:logging/logging.dart';

abstract class LogRecordParser {
  const LogRecordParser();
  LogRecord call(String value) => parse(value);
  LogRecord parse(String value);
}
