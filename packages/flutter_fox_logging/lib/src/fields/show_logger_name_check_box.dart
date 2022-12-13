import 'package:flutter/material.dart';
import 'package:flutter_fox_logging/src/models/field_visibilities.dart';
import 'package:flutter_fox_logging/src/models/logs_controller.dart';

class ShowLoggerNameCheckBox extends StatelessWidget {
  const ShowLoggerNameCheckBox({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = LogsController.of(context);
    return ValueListenableBuilder<FieldVisibilitiesData>(
      valueListenable: controller.visibleFields,
      builder: (context, fields, oldWidget) => Row(children: [
        Checkbox(
          value: fields.loggerName,
          onChanged: (value) {
            controller.visibleFields.value = fields.copyWith(loggerName: value);
          },
        ),
        const Text('Logger name'),
      ]),
    );
  }
}
