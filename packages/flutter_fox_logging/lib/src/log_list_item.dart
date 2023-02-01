import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fox_logging/src/field_visibilities.dart';
import 'package:flutter_fox_logging/src/log_detail_screen.dart';
import 'package:fox_logging/fox_logging.dart';

class LogListItem extends StatelessWidget {
  const LogListItem({
    super.key,
    required this.logRecord,
    this.color,
    this.icon,
    this.visualDensity = const VisualDensity(vertical: -4),
    this.detailScreenBuilder,
    this.visibleFields,
  });

  final LogRecord logRecord;
  final Color? color;
  final IconData? icon;
  final VisualDensity visualDensity;
  final Widget Function(LogRecord log)? detailScreenBuilder;
  final ValueListenable<LogFieldVisibilities>? visibleFields;

  @override
  Widget build(BuildContext context) {
    final visibleFields = this.visibleFields;
    if (visibleFields == null) {
      return _listTile(context, const LogFieldVisibilities());
    }
    return ValueListenableBuilder<LogFieldVisibilities>(
      valueListenable: visibleFields,
      builder: (context, visibleFields, _) => _listTile(context, visibleFields),
    );
  }

  Widget _listTile(BuildContext context, LogFieldVisibilities visibleFields) {
    final theme = Theme.of(context);
    return ListTile(
      visualDensity: visualDensity,
      leading: _icon(theme, icon, color, visibleFields.icon),
      title: _title(color),
      subtitle: _loggerName(visibleFields.loggerName),
      trailing: _time(theme, visibleFields.time),
      onTap: () => onTap(context, icon, color),
    );
  }

  Widget? _icon(ThemeData theme, IconData? icon, Color? color, bool isVisible) {
    if (!isVisible) {
      return null;
    } else if (icon == null) {
      return SizedBox(width: theme.iconTheme.size);
    }

    return Icon(icon, color: color);
  }

  Widget _title(Color? color) {
    return Text(logRecord.message, style: TextStyle(color: color));
  }

  Widget? _loggerName(bool isVisible) {
    return isVisible ? Text(logRecord.loggerName) : null;
  }

  Widget? _time(ThemeData theme, bool isVisible) {
    if (!isVisible) {
      return null;
    }
    final time = logRecord.time;
    return Text(
      '${time.year}-${time.month}-${time.day}\n'
      '${time.hour}:${time.minute}:${time.second}.${time.millisecond}',
      textAlign: TextAlign.end,
      style: theme.textTheme.bodySmall,
    );
  }

  void onTap(BuildContext context, IconData? icon, Color? color) {
    final detailScreenBuilder = this.detailScreenBuilder;
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      if (detailScreenBuilder == null) {
        return LogDetailScreen(
          logRecord: logRecord,
          color: color,
          icon: icon,
        );
      }
      return detailScreenBuilder(logRecord);
    }));
  }
}
