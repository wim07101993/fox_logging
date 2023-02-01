import 'dart:async';

import 'package:fox_logging/src/sink/log_record_list.dart';
import 'package:fox_logging/src/sink/log_sink.dart';
import 'package:logging/logging.dart';

/// Writes logs to an in memory buffer. Either with fixed size or unlimited
/// size.
class MemoryLogSink with LogSinkMixin {
  MemoryLogSink._(this._logRecords);

  /// Creates a [MemoryLogSink] with a fixed buffer size.
  ///
  /// When the buffer is full, the oldest item is removed to make room for the
  /// new one.
  MemoryLogSink.fixedBuffer({
    int bufferSize = 200,
  }) : this._(LogRecordList.limited(bufferSize));

  /// Creates a [MemoryLogSink] with a unlimited buffer.
  MemoryLogSink.variableBuffer() : this._(LogRecordList.infinite());

  final LogRecordList _logRecords;

  /// A copy of the current buffer.
  Iterable<LogRecord> get logRecords => _logRecords.toIterable();

  /// Adds [logRecord] to the [logRecords].
  @override
  Future<void> write(LogRecord logRecord) {
    _logRecords.add(logRecord);
    return Future.value();
  }

  /// Clears the buffer and cancels all subscriptions to streams.
  @override
  Future<void> dispose() {
    _logRecords.clear();
    return super.dispose();
  }
}
