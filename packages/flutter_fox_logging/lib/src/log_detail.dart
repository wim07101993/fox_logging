import 'package:flutter/material.dart';
import 'package:fox_logging/fox_logging.dart';

class LogDetail extends StatelessWidget {
  const LogDetail({
    super.key,
    required this.logRecord,
    this.color,
    this.icon,
  });

  final LogRecord logRecord;
  final Color? color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loggerName = logRecord.loggerName;
    final stackTrace = logRecord.stackTrace;
    final time = logRecord.time;
    final object = logRecord.object;
    final error = logRecord.error;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: header(theme),
          ),
          field(theme, 'loggerName', loggerName),
          field(theme, 'time', time.toString()),
          if (object != null) field(theme, 'object', object.toString()),
          if (error != null) field(theme, 'error', error.toString()),
          if (stackTrace != null)
            field(
              theme,
              'stackTrace',
              stackTrace.toString(),
            ),
        ],
      ),
    );
  }

  Widget header(ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon != null) Icon(icon, size: 64, color: color),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            logRecord.message,
            softWrap: true,
            style: theme.textTheme.headline5,
          ),
        ),
      ],
    );
  }

  Widget field(ThemeData theme, String name, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(name, style: theme.textTheme.caption),
          Text(value),
        ],
      ),
    );
  }
}
