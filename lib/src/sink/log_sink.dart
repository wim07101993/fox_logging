import 'dart:async';

import 'package:fox_logging/src/filter/log_filter.dart';
import 'package:logging/logging.dart';

/// Listens to log-streams and writes them to a destination.
mixin LogSinkMixin {
  final List<StreamSubscription> _logSubscriptions = List.empty(growable: true);

  LogFilter get filter;

  /// Starts listening for new log-records from the [logStream].
  void listenTo(Stream<LogRecord> logStream) {
    _logSubscriptions.add(
      logStream.where((logRecord) => filter.shouldLog(logRecord)).listen(write),
    );
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

/// Listens to log-streams and writes them to a destination.
///
/// This class is deprecated, use LogSinkMixin instead.
abstract class LogSink with LogSinkMixin {
  LogSink([this.filter = const LogFilter.none()]);

  @override
  final LogFilter filter;
}
