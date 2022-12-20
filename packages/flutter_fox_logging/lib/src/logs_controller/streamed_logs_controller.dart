import 'dart:async';

import 'package:flutter_fox_logging/src/logs_controller/logs_controller.dart';
import 'package:fox_logging/fox_logging.dart';

class StreamedLogsController extends LogsController {
  StreamedLogsController({
    required Stream<LogRecord> logs,
  }) : super() {
    _subscription = logs.listen((logRecord) => super.addLog(logRecord));
  }

  late final StreamSubscription _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
