import 'dart:async';

import 'package:logging/logging.dart';

/// Listens to log-streams and writes them to a destination.
abstract class LogSink {
  final List<StreamSubscription> _logSubscriptions = List.empty(growable: true);

  /// Starts listening for new log-records from the [logStream].
  void listenTo(Stream<LogRecord> logStream) {
    _logSubscriptions.add(logStream.listen(write));
  }

  /// Cancels all subscriptions to log-streams.
  Future<void> dispose() {
    return Future.wait(
      _logSubscriptions.map((subscription) => subscription.cancel()),
    );
  }

  /// Writes [logRecord] to wherever this sink goes.
  Future<void> write(LogRecord logRecord);
}
