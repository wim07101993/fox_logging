import 'package:logging/logging.dart';

abstract class LogRecordFormatter {
  String format(LogRecord logRecord);
}
