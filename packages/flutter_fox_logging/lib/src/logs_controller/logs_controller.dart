import 'package:flutter/foundation.dart';
import 'package:fox_logging/fox_logging.dart';

class LogsController extends ChangeNotifier
    implements ValueListenable<Iterable<LogRecord>> {
  LogsController({
    LogRecordList? logs,
    ValueNotifier<Level>? minimumLevel,
    ValueNotifier<Map<String, bool>>? loggers,
  })  : _allLogs = logs ?? LogRecordList.infinite(),
        minimumLevel = minimumLevel ?? ValueNotifier(Level.ALL),
        loggers = loggers ??
            ValueNotifier(
              logs == null
                  ? <String, bool>{}
                  : {for (final log in logs.toIterable()) log.loggerName: true},
            ) {
    this.minimumLevel.addListener(notifyListeners);
    this.loggers.addListener(notifyListeners);
  }

  final ValueNotifier<Level> minimumLevel;
  final ValueNotifier<Map<String, bool>> loggers;

  LogRecordList _allLogs;

  @override
  Iterable<LogRecord> get value => _allLogs.toIterable().where(applyFilter);

  Iterable<String> get allLoggers =>
      _allLogs.toIterable().map((l) => l.loggerName).toSet();

  set value(Iterable<LogRecord> value) {
    if (value is LogRecordList) {
      _allLogs = value as LogRecordList;
    } else {
      _allLogs = LogRecordList.infinite(value);
    }
    notifyListeners();
  }

  void addLog(LogRecord logRecord) {
    _allLogs.add(logRecord);
    notifyListeners();
  }

  @override
  void dispose() {
    minimumLevel.removeListener(notifyListeners);
    loggers.removeListener(notifyListeners);
    super.dispose();
  }

  bool applyFilter(LogRecord logRecord) {
    final minimumLevel = this.minimumLevel.value;
    final loggers = this.loggers.value;
    return logRecord.level.value >= minimumLevel.value &&
        (loggers.isEmpty || (loggers[logRecord.loggerName] ?? false));
  }
}
