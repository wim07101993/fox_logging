import 'dart:async';

import 'package:fox_logging/src/filter/log_filter.dart';
import 'package:logging/logging.dart';

/// Listens to log-streams and writes them to a destination.
mixin LogSinkMixin {
  final List<StreamSubscription> _logSubscriptions = List.empty(growable: true);

  /// Decides which log-records make it to [write].
  LogFilter get filter;

  /// Starts listening for new log-records from the [logStream].
  void listenTo(Stream<LogRecord> logStream) {
    _logSubscriptions.add(logStream.listen(log, onError: onError));
  }

  /// Writes [logRecord] to this sink, if [filter] allows it.
  ///
  /// This is the entry-point of a sink: it applies the [filter] and shields
  /// the caller from errors thrown by [write]. Use this rather than [write]
  /// when handing a log-record to a sink.
  Future<void> log(LogRecord logRecord) async {
    if (!filter.shouldLog(logRecord)) {
      return;
    }
    try {
      await write(logRecord);
    } catch (error, stackTrace) {
      onError(error, stackTrace);
    }
  }

  /// Called when [write] fails or when a log-stream emits an error.
  ///
  /// Does nothing by default: a failing sink should not take down the program
  /// it is logging for. Override this to report the failure somewhere else.
  void onError(Object error, StackTrace stackTrace) {}

  /// Cancels all subscriptions to log-streams and releases the resources of
  /// this sink.
  ///
  /// Overriders should call `super.dispose()`.
  Future<void> dispose() {
    final subscriptions = List.of(_logSubscriptions);
    _logSubscriptions.clear();
    return Future.wait(
      subscriptions.map((subscription) => subscription.cancel()),
    );
  }

  /// Writes [logRecord] to wherever this sink goes, without applying [filter].
  ///
  /// Implement this to create a sink; call [log] to use one.
  Future<void> write(LogRecord logRecord);
}

/// Listens to log-streams and writes them to a destination.
///
/// This class is deprecated, use [LogSinkMixin] instead.
@Deprecated('Use LogSinkMixin instead')
abstract class LogSink with LogSinkMixin {
  @Deprecated('Use LogSinkMixin instead')
  LogSink([this.filter = const LogFilter.none()]);

  @override
  final LogFilter filter;
}
