import 'package:logging/logging.dart';

/// Formats [LogRecord] to a [String]. This is used by various [LogSinkMixin]
/// implementations.
abstract class LogRecordFormatter {
  /// Const constructor for the extending classes.
  const LogRecordFormatter();

  /// Calls [format]
  String call(LogRecord logRecord) => format(logRecord);

  /// Formats a given [LogRecord] to a [String].
  String format(LogRecord logRecord);
}
