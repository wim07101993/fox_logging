import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_fox_logging/src/logs_screen/controller_logs_screen.dart';
import 'package:flutter_fox_logging/src/logs_screen/stream_logs_screen.dart';
import 'package:flutter_fox_logging/src/models/logs_controller.dart';
import 'package:fox_logging/fox_logging.dart';

abstract class LogsScreen implements Widget {
  const factory LogsScreen.controller({
    Key? key,
    required LogsController controller,
    Converter<Level, Color?> colors,
    Converter<Level, IconData?> icons,
    VisualDensity visualDensity,
  }) = ControllerLogsScreen;

  const factory LogsScreen.stream({
    Key? key,
    required Stream<LogRecord> stream,
    Converter<Level, Color?> colors,
    Converter<Level, IconData?> icons,
    VisualDensity visualDensity,
  }) = StreamLogsScreen;
}
