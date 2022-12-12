import 'package:flutter/material.dart';
import 'package:flutter_fox_logging/src/logs_controller_provider.dart';
import 'package:flutter_fox_logging/src/models/logs_controller.dart';
import 'package:fox_logging/fox_logging.dart';

import 'log_detail.dart';

class LogDetailScreen extends StatelessWidget {
  const LogDetailScreen({
    Key? key,
    required this.logRecord,
    required this.controller,
    this.color,
    this.icon,
  }) : super(key: key);

  final LogRecord logRecord;
  final Color? color;
  final IconData? icon;
  final LogsController controller;

  @override
  Widget build(BuildContext context) {
    return LogsControllerProvider.builder(
      controller: controller,
      builder: (context) => Scaffold(
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
      ),
    );
  }
}
