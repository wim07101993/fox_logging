import 'dart:async';
import 'dart:collection';

import 'package:logging/logging.dart';
import 'package:logging_extensions/src/sink/log_sink.dart';

class MemorySink extends LogSink {
  MemorySink({
    int bufferSize = 200,
  }) : _logRecords = bufferSize < 0
            ? _LogRecordList.infinite()
            : _LogRecordList.limited(bufferSize);

  final _LogRecordList _logRecords;
  List<LogRecord> get logRecords => _logRecords.toList();

  @override
  Future<void> write(LogRecord logRecord) {
    _logRecords.add(logRecord);
    return Future.value();
  }

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

class _LimitedLogRecordList extends ListQueue<LogRecord>
    implements _LogRecordList {
  _LimitedLogRecordList(int size) : super(size);
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
