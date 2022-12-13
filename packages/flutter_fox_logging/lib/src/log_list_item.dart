import 'package:flutter/material.dart';
import 'package:flutter_fox_logging/src/log_detail_screen.dart';
import 'package:flutter_fox_logging/src/models/field_visibilities.dart';
import 'package:flutter_fox_logging/src/models/logs_controller.dart';
import 'package:fox_logging/fox_logging.dart';

class LogListItem extends StatelessWidget {
  const LogListItem({
    super.key,
    required this.logRecord,
    this.color,
    this.icon,
    this.visualDensity = const VisualDensity(vertical: -4),
    this.detailScreenBuilder,
  });

  final LogRecord logRecord;
  final Color? color;
  final IconData? icon;
  final VisualDensity visualDensity;
  final Widget Function(LogRecord log)? detailScreenBuilder;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = LogsController.of(context);
    return ValueListenableBuilder<FieldVisibilitiesData>(
      valueListenable: controller.visibleFields,
      builder: (context, fields, oldWidget) => ListTile(
        visualDensity: visualDensity,
        leading: _icon(theme, fields, icon, color),
        title: _title(color),
        subtitle: _subtitle(fields),
        trailing: _time(theme, fields),
        onTap: () => onTap(context, icon, color),
      ),
    );
  }

  Widget? _icon(
    ThemeData theme,
    FieldVisibilitiesData fields,
    IconData? icon,
    Color? color,
  ) {
    if (!fields.icon) {
      return null;
    } else if (icon == null) {
      return SizedBox(width: theme.iconTheme.size);
    }

    return Icon(icon, color: color);
  }

  Widget _title(Color? color) {
    return Text(logRecord.message, style: TextStyle(color: color));
  }

  Widget? _subtitle(FieldVisibilitiesData fields) {
    return fields.loggerName ? Text(logRecord.loggerName) : null;
  }

  Widget? _time(ThemeData theme, FieldVisibilitiesData fields) {
    if (!fields.time) {
      return null;
    }
    final time = logRecord.time;
    return Text(
      '${time.year}-${time.month}-${time.day}\n'
      '${time.hour}:${time.minute}:${time.second}.${time.millisecond}',
      textAlign: TextAlign.end,
      style: theme.textTheme.caption,
    );
  }

  void onTap(BuildContext context, IconData? icon, Color? color) {
    final detailScreenBuilder = this.detailScreenBuilder;
    final controller = LogsController.of(context);
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      if (detailScreenBuilder == null) {
        return LogDetailScreen(
          controller: controller,
          logRecord: logRecord,
          color: color,
          icon: icon,
        );
      }
      return detailScreenBuilder(logRecord);
    }));
  }
}
