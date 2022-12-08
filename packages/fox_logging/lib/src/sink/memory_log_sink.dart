import 'dart:async';

import 'package:logging/logging.dart';
import 'package:fox_logging/src/sink/log_sink.dart';

/// Writes logs to an in memory buffer. Either with fixed size or unlimited
/// size.
class MemoryLogSink extends LogSink {
  MemoryLogSink._(this._logRecords);

  /// Creates a [MemoryLogSink] with a fixed buffer size.
  ///
  /// When the buffer is full, the oldest item is removed to make room for the
  /// new one.
  MemoryLogSink.fixedBuffer({
    int bufferSize = 200,
  }) : this._(_LogRecordList.limited(bufferSize));

  /// Creates a [MemoryLogSink] with a unlimited buffer.
  MemoryLogSink.variableBuffer() : this._(_LogRecordList.infinite());

  final _LogRecordList _logRecords;

  /// A copy of the current buffer.
  List<LogRecord> get logRecords => _logRecords.toList();

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

abstract class _LogRecordList {
  factory _LogRecordList.infinite() = _InfiniteLogRecordList;
  factory _LogRecordList.limited(int size) = _LimitedLogRecordList;

  void add(LogRecord logRecord);
  List<LogRecord> toList();
  void clear();
}

class _LimitedLogRecordList implements _LogRecordList {
  _LimitedLogRecordList(this.size);

  final List<LogRecord> _list = List.empty(growable: true);
  final int size;

  int nextWriteIndex = 0;

  @override
  void add(LogRecord logRecord) {
    if (_list.length < size) {
      _list.add(logRecord);
    } else {
      _list[nextWriteIndex] = logRecord;
      nextWriteIndex++;
      if (nextWriteIndex >= size) {
        nextWriteIndex = 0;
      }
    }
  }

  @override
  void clear() {
    nextWriteIndex = 0;
    _list.clear();
  }

  @override
  List<LogRecord> toList() {
    if (_list.length < size) {
      return _list.toList(growable: false);
    } else {
      final startIndex = nextWriteIndex > 0 ? nextWriteIndex - 1 : size - 1;
      return List.unmodifiable([
        ..._list.sublist(startIndex),
        ..._list.sublist(0, startIndex),
      ]);
    }
  }
}

class _InfiniteLogRecordList implements _LogRecordList {
  final List<LogRecord> _list = [];

  @override
  void add(LogRecord record) => _list.add(record);

  @override
  List<LogRecord> toList() => List.unmodifiable(_list);

  @override
  void clear() => _list.clear();
}
