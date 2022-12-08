import 'package:flutter/material.dart';
import 'package:flutter_fox_logging/src/models/logs_controller.dart';

class LoggerCheckBox extends StatelessWidget {
  const LoggerCheckBox({
    Key? key,
    required this.logger,
  }) : super(key: key);

  final String logger;

  @override
  Widget build(BuildContext context) {
    final controller = LogsController.of(context);
    final selectedLoggersNotifier = controller.filter.loggers;
    return Row(children: [
      ValueListenableBuilder<Map<String, bool>>(
        valueListenable: selectedLoggersNotifier,
        builder: (context, selectedLoggers, oldWidget) {
          return Checkbox(
            value:
                selectedLoggers.isEmpty || (selectedLoggers[logger] ?? false),
            onChanged: (value) {
              final map = Map<String, bool>.from(selectedLoggers);
              map[logger] = value ?? false;
              selectedLoggersNotifier.value = map;
            },
          );
        },
      ),
      Text(logger),
    ]);
  }
}
