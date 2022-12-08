import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_fox_logging/src/logs_controller_provider.dart';
import 'package:flutter_fox_logging/src/models/field_visibilities.dart';
import 'package:flutter_fox_logging/src/models/filter.dart';
import 'package:fox_logging/fox_logging.dart';

class LogsController extends ChangeNotifier
    implements ValueListenable<Iterable<LogRecord>> {
  LogsController({
    List<LogRecord>? logs,
    Filter? filter,
    FieldVisibilities? fields,
  })  : filter = filter ?? Filter(),
        visibleFields = fields ?? FieldVisibilities(),
        visibleLoggers = ValueNotifier([]),
        visibleLevels = ValueNotifier([]),
        _allLogs = logs ?? [] {
    this.filter.addListener(super.notifyListeners);
    updateLoggers();
    updateLevels();
  }

  final FieldVisibilities visibleFields;
  final Filter filter;

  List<LogRecord> _allLogs;

  @override
  Iterable<LogRecord> get value => _allLogs.where(filter.apply);

  final ValueNotifier<List<String>> visibleLoggers;
  final ValueNotifier<List<Level>> visibleLevels;

  set value(Iterable<LogRecord> value) {
    _allLogs = value.toList();
    notifyListeners();
  }

  void addLog(LogRecord logRecord) {
    _allLogs.add(logRecord);
    notifyListeners();
  }

  @override
  void notifyListeners() {
    updateLoggers();
    updateLevels();
    super.notifyListeners();
  }

  void updateLoggers() {
    final oldLoggers = visibleLoggers.value;
    final newLoggers = _allLogs.map((l) => l.loggerName).toSet().toList()
      ..sort();
    if (newLoggers.length != oldLoggers.length) {
      visibleLoggers.value = newLoggers;
    } else {
      for (var i = 0; i < newLoggers.length; i++) {
        if (newLoggers[i] != oldLoggers[i]) {
          visibleLoggers.value = newLoggers;
          break;
        }
      }
    }

    final selectedLoggers = Map<String, bool>.from(filter.loggers.value);
    for (final logger in visibleLoggers.value) {
      if (!selectedLoggers.containsKey(logger)) {
        selectedLoggers[logger] = true;
      }
    }
    filter.loggers.value = selectedLoggers;
  }

  void updateLevels() {
    final oldLevels = visibleLevels.value;
    final newLevels = {
      ...Level.LEVELS,
      ..._allLogs.map((l) => l.level),
    }.toList()
      ..sort((a, b) => a.value.compareTo(b.value));
    if (newLevels.length != oldLevels.length) {
      visibleLevels.value = newLevels;
    } else {
      for (var i = 0; i < newLevels.length; i++) {
        if (newLevels[i] != oldLevels[i]) {
          visibleLevels.value = newLevels;
          break;
        }
      }
    }
  }

  static LogsController of(BuildContext context) {
    final result =
        context.dependOnInheritedWidgetOfExactType<LogsControllerProvider>();
    if (result == null) {
      throw AssertionError('No LogsController found in context');
    }
    return result.controller;
  }
}
