import 'package:flutter/material.dart';
import 'package:flutter_fox_logging/src/labeled_check_box.dart';
import 'package:flutter_fox_logging/src/logs_controller/logs_controller.dart';
import 'package:fox_logging/fox_logging.dart';

class SelectLoggersDialog extends StatelessWidget {
  const SelectLoggersDialog({
    super.key,
    required this.controller,
  });

  final LogsController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Iterable<LogRecord>>(
      valueListenable: controller,
      builder: (context, logs, _) => _dialog(),
    );
  }

  Widget _dialog() {
    final possibleLoggers = controller.allLoggers;
    final enabledLoggers = controller.loggers.value;
    final areAllLoggersEnabled =
        enabledLoggers.length == possibleLoggers.length &&
            enabledLoggers.values.every((isEnabled) => isEnabled);

    return SimpleDialog(
      title: const Text('Select loggers'),
      children: [
        LabeledCheckBox(
          value: areAllLoggersEnabled,
          onChanged: (isSelected) => isSelected == true
              ? enableAllLoggers(possibleLoggers)
              : disableAllLoggers(possibleLoggers),
          label: const Text('All'),
        ),
        ...possibleLoggers.map(
          (logger) => LabeledCheckBox(
            value: enabledLoggers[logger] ?? false,
            onChanged: (isSelected) => isSelected == true
                ? enableLogger(logger)
                : disableLogger(logger),
            label: Text(logger),
          ),
        ),
      ],
    );
  }

  void enableAllLoggers(Iterable<String> possibleLoggers) {
    controller.loggers.value = {
      for (final logger in possibleLoggers) logger: true,
    };
  }

  void disableAllLoggers(Iterable<String> possibleLoggers) {
    controller.loggers.value = {
      for (final logger in possibleLoggers) logger: false,
    };
  }

  void enableLogger(String loggerName) {
    controller.loggers.value = {
      ...controller.loggers.value,
      loggerName: true,
    };
  }

  void disableLogger(String loggerName) {
    controller.loggers.value = {
      ...controller.loggers.value,
      loggerName: false,
    };
  }
}
