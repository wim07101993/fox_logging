import 'package:logging/logging.dart';

/// Parses a [String] into a [LogRecord].
abstract class LogRecordParser {
  /// Const constructor for extending classes.
  const LogRecordParser();

  /// Calls [parse].
  LogRecord call(String value) => parse(value);

  /// Parses a given [String] into a [LogRecord].
  LogRecord parse(String value);

  /// Parses [String] into a list of [LogRecord].
  Iterable<LogRecord> parseList(String value);
}
