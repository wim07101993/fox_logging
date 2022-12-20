import 'package:flutter/material.dart';
import 'package:flutter_fox_logging/src/filter/level_filter_selector.dart';
import 'package:flutter_fox_logging/src/filter/logger_selector.dart';
import 'package:flutter_fox_logging/src/logs_controller.dart';

class LogsFilter extends StatelessWidget {
  const LogsFilter({
    super.key,
    required this.controller,
  });

  final LogsController controller;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      LevelFilterSelector(controller: controller.minimumLevel),
      const SizedBox(height: 16),
      LoggerSelector(controller: controller),
    ]);
  }
}
