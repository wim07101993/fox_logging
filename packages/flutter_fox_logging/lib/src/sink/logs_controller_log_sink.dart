import 'package:flutter_fox_logging/src/logs_controller/logs_controller.dart';
import 'package:fox_logging/fox_logging.dart';

class LogsControllerLogSink extends LogSink {
  LogsControllerLogSink({
    required this.controller,
  });

  final LogsController controller;

  @override
  Future<void> write(LogRecord logRecord) {
    controller.addLog(logRecord);
    return Future.value();
  }
}
