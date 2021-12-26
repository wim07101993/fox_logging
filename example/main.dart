import 'dart:developer';

import 'package:logging_extensions/logging_extensions.dart';

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
  final simplePrint = PrintSink(SimpleFormatter())
    ..listenTo(simpleLogger.onRecord);

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

  simplePrint.dispose();

  final prettyLogger = Logger('Pretty');
  final prettySink = PrintSink(PrettyFormatter())
    ..listenTo(prettyLogger.onRecord);

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

  prettySink.dispose();
}
