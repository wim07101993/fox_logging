import 'package:flutter/foundation.dart';
import 'package:fox_logging/fox_logging.dart';

class Filter extends ChangeNotifier {
  Filter({
    String searchString = '',
    Level minimumLevel = Level.ALL,
    Map<String, bool> loggers = const {},
  })  : searchString = ValueNotifier(searchString),
        minimumLevel = ValueNotifier(minimumLevel),
        loggers = ValueNotifier(loggers) {
    this.searchString.addListener(notifyListeners);
    this.minimumLevel.addListener(notifyListeners);
    this.loggers.addListener(notifyListeners);
  }

  final ValueNotifier<String> searchString;
  final ValueNotifier<Level> minimumLevel;
  final ValueNotifier<Map<String, bool>> loggers;

  bool apply(LogRecord logRecord) {
    final minimumLevel = this.minimumLevel.value;
    final loggers = this.loggers.value;
    final searchString = this.searchString.value;
    return logRecord.level.value >= minimumLevel.value &&
        (loggers.isEmpty || (loggers[logRecord.loggerName] ?? false)) &&
        (searchString.isEmpty || logRecord.message.contains(searchString));
  }

  @override
  void dispose() {
    searchString.removeListener(notifyListeners);
    minimumLevel.removeListener(notifyListeners);
    loggers.removeListener(notifyListeners);
    super.dispose();
  }
}
