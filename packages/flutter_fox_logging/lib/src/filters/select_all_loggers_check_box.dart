import 'package:flutter/material.dart';
import 'package:flutter_fox_logging/src/models/logs_controller.dart';

class SelectAllLoggersCheckBox extends StatelessWidget {
  const SelectAllLoggersCheckBox({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = LogsController.of(context);
    final allLoggersNotifier = controller.visibleLoggers;
    final selectedLoggersNotifier = controller.filter.loggers;
    return Row(children: [
      ValueListenableBuilder<Map<String, bool>>(
        valueListenable: selectedLoggersNotifier,
        builder: (context, selectedLoggers, oldWidget) {
          return Checkbox(
            value: selectedLoggers.isEmpty ||
                selectedLoggers.values.every((v) => v),
            onChanged: (value) {
              selectedLoggersNotifier.value = {
                for (var logger in allLoggersNotifier.value)
                  logger: value ?? false
              };
            },
          );
        },
      ),
      const Text('All'),
    ]);
  }
}
