import 'package:fox_logging/fox_logging.dart';

abstract class LogRecordList {
  factory LogRecordList.infinite([Iterable<LogRecord>? logs]) =
      _InfiniteLogRecordList;
  factory LogRecordList.limited(
    int size, [
    Iterable<LogRecord>? logs,
  ]) = _LimitedLogRecordList;

  void add(LogRecord logRecord);
  Iterable<LogRecord> toIterable();
  void clear();
}

class _LimitedLogRecordList implements LogRecordList {
  _LimitedLogRecordList(
    this.size, [
    Iterable<LogRecord>? logs,
  ]) {
    if (logs == null) {
      _list = List<LogRecord>.empty(growable: true);
      return;
    } else {
      final list = logs.toList();
      if (list.length <= size) {
        _list = list;
      } else {
        _list = list.sublist(list.length - size);
      }
    }
  }
  late final List<LogRecord> _list;
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
  Iterable<LogRecord> toIterable() sync* {
    if (_list.length < size) {
      yield* _list;
    } else {
      final startIndex = nextWriteIndex > 0 ? nextWriteIndex - 1 : size - 1;
      yield* _list.sublist(startIndex);
      yield* _list.sublist(0, startIndex);
    }
  }
}

class _InfiniteLogRecordList implements LogRecordList {
  _InfiniteLogRecordList([
    Iterable<LogRecord>? logs,
  ]) : _list = logs?.toList() ?? List<LogRecord>.empty(growable: true);

  final List<LogRecord> _list;

  @override
  void add(LogRecord record) => _list.add(record);

  @override
  Iterable<LogRecord> toIterable() sync* {
    yield* _list;
  }

  @override
  void clear() => _list.clear();
}
