import 'package:flutter/material.dart';
import 'package:flutter_fox_logging/src/filter/select_loggers_dialog.dart';
import 'package:flutter_fox_logging/src/logs_controller/logs_controller.dart';

class LoggerSelector extends StatelessWidget {
  const LoggerSelector({
    super.key,
    required this.controller,
  });

  final LogsController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: ValueListenableBuilder<Map<String, bool>>(
            valueListenable: controller.loggers,
            builder: (context, loggers, _) => _loggers(
              theme,
              loggers.entries.where((e) => e.value).map((e) => e.key).toList(),
            ),
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          onPressed: () => _selectLogger(context),
          child: const Text('Select'),
        ),
      ],
    );
  }

  Widget _loggers(ThemeData theme, List<String> loggers) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Loggers', style: theme.textTheme.bodySmall),
        if (loggers.isEmpty)
          const Text('None')
        else
          loggers.length == 1
              ? Text(loggers[0])
              : RichText(
                  text: TextSpan(
                    children: [
                      ...loggers
                          .take(loggers.length - 1)
                          .map((l) => TextSpan(text: '$l, ')),
                      TextSpan(text: loggers.last),
                    ],
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
      ],
    );
  }

  void _selectLogger(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => SelectLoggersDialog(controller: controller),
    );
  }
}
