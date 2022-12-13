import 'package:flutter/material.dart';
import 'package:flutter_fox_logging/src/filters/logger_check_box.dart';
import 'package:flutter_fox_logging/src/filters/select_all_loggers_check_box.dart';
import 'package:flutter_fox_logging/src/logs_controller_provider.dart';
import 'package:flutter_fox_logging/src/models/logs_controller.dart';

class SelectLoggersDialog extends StatelessWidget {
  const SelectLoggersDialog({
    super.key,
    required this.controller,
  });

  final LogsController controller;

  @override
  Widget build(BuildContext context) {
    return LogsControllerProvider.builder(
      controller: controller,
      builder: (context) => ValueListenableBuilder<List<String>>(
        valueListenable: controller.visibleLoggers,
        builder: (context, allLoggers, oldWidget) => SimpleDialog(
          title: const Text('Select loggers'),
          children: [
            const SelectAllLoggersCheckBox(),
            ...allLoggers.map((logger) => LoggerCheckBox(logger: logger)),
          ],
        ),
      ),
    );
  }
}
