import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fox_logging/flutter_fox_logging.dart';

final logger = Logger('root');
final secondLogger = Logger('my-custom-logger');

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  hierarchicalLoggingEnabled = true;
  recordStackTraceAtLevel = Level.SEVERE;
  Logger.root.level = Level.ALL;

  Future.delayed(const Duration(seconds: 1), () async {
    logger.finest('This is a verbose message');
    await Future.delayed(const Duration(seconds: 1));
    logger.finer('This is a debug message');
    await Future.delayed(const Duration(seconds: 1));
    secondLogger.fine('This is a fine message');
    await Future.delayed(const Duration(seconds: 1));
    logger.config('Configured api');
    await Future.delayed(const Duration(seconds: 1));
    logger.info('This actually looks quiet nice');
    await Future.delayed(const Duration(seconds: 1));
    secondLogger.warning('Null-pointers ahead');
    await Future.delayed(const Duration(seconds: 1));
    logger.severe(
      'Null reference exception ...',
      NullThrownError(),
      StackTrace.current,
    );
    await Future.delayed(const Duration(seconds: 1));
    secondLogger.shout('I told you to look out for null-pointers');
    await Future.delayed(const Duration(seconds: 1));
    secondLogger.finest('This is a verbose message');
    await Future.delayed(const Duration(seconds: 1));
    secondLogger.finer('This is a debug message');
    await Future.delayed(const Duration(seconds: 1));
    logger.fine('This is a fine message');
    await Future.delayed(const Duration(seconds: 1));
    secondLogger.config('Configured api');
    await Future.delayed(const Duration(seconds: 1));
    secondLogger.info('This actually looks quiet nice');
    await Future.delayed(const Duration(seconds: 1));
    logger.warning('Null-pointers ahead');
    await Future.delayed(const Duration(seconds: 1));
    secondLogger.severe(
      'Null reference exception ...',
      NullThrownError(),
      StackTrace.current,
    );
    await Future.delayed(const Duration(seconds: 1));
    logger.shout('I told you to look out for null-pointers');
  });

  runApp(
    MaterialApp(
      home: LogsScreen(
        controller: StreamedLogsController(
          logs: StreamGroup.merge([
            logger.onRecord,
            secondLogger.onRecord,
          ]),
        ),
      ),
    ),
  );
}
