import 'dart:developer';

import 'package:logging/logging.dart';
import 'package:logging_extensions/src/formatter/pretty_formatter.dart';
import 'package:logging_extensions/src/formatter/simple_formatter.dart';

void main() {
  log(
    'message',
    time: DateTime.now(),
    sequenceNumber: 23,
    level: 800,
    name: 'logger name',
    error: 'my fancy error',
    stackTrace: StackTrace.current,
  );
  Logger.root.level = Level.ALL;
  hierarchicalLoggingEnabled = true;
  final simpleLogger = Logger('Simple');
  final simpleFormatter = SimpleFormatter();
  simpleLogger.onRecord.map(simpleFormatter.format).listen(print);

  simpleLogger.finest('This is a verbose message');
  simpleLogger.finer('This is a debug message');
  simpleLogger.fine('This is a fine message');
  simpleLogger.config('Configured api');
  simpleLogger.info('This actually looks quiet nice');
  simpleLogger.warning('Null-pointers ahead');
  simpleLogger.severe(
    'Null reference exception ...',
    NullThrownError(),
    StackTrace.current,
  );
  simpleLogger.shout('I told you to look out for null-pointers');

  final prettyLogger = Logger('Pretty');
  final prettyFormatter = PrettyFormatter();
  prettyLogger.onRecord.map(prettyFormatter.format).listen(print);

  prettyLogger.finest('This is a verbose message');
  prettyLogger.finer('This is a debug message');
  prettyLogger.fine('This is a fine message');
  prettyLogger.config('Configured api');
  prettyLogger.info('This actually looks quiet nice');
  prettyLogger.warning('Null-pointers ahead');
  prettyLogger.severe(
    'Null reference exception ...',
    NullThrownError(),
    StackTrace.current,
  );
  prettyLogger.shout('I told you to look out for null-pointers');
}
