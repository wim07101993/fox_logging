import 'package:flutter/material.dart';
import 'package:flutter_fox_logging/src/log_detail.dart';
import 'package:fox_logging/fox_logging.dart';

class LogDetailScreen extends StatelessWidget {
  const LogDetailScreen({
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
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        backgroundColor: color,
        title: Text(logRecord.level.name),
      ),
      body: LogDetail(
        logRecord: logRecord,
        color: color,
        icon: icon,
      ),
    );
  }
}
