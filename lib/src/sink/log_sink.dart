import 'dart:async';

import 'package:logging/logging.dart';

abstract class LogSink {
  final List<StreamSubscription> logSubscriptions = List.empty(growable: true);

  void listenTo(Stream<LogRecord> logStream) {
    logSubscriptions.add(logStream.listen(write));
  }

  Future<void> dispose() {
    return Future.wait(
      logSubscriptions.map((subscription) => subscription.cancel()),
    );
  }

  Future<void> write(LogRecord logRecord);
}
