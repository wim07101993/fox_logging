import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_fox_logging/flutter_fox_logging.dart';

class StreamLogsScreen extends StatefulWidget implements LogsScreen {
  const StreamLogsScreen({
    Key? key,
    required this.stream,
    this.colors = const LogLevelToColorConverter(),
    this.icons = const LogLevelToIconConverter(),
    this.visualDensity = const VisualDensity(horizontal: 0, vertical: -4),
  }) : super(key: key);

  final Stream<LogRecord> stream;
  final Converter<Level, Color?> colors;
  final Converter<Level, IconData?> icons;
  final VisualDensity visualDensity;

  @override
  State<StreamLogsScreen> createState() => _StreamLogsScreenState();
}

class _StreamLogsScreenState extends State<StreamLogsScreen> {
  late final LogsController controller;
  late StreamSubscription subscription;

  @override
  void initState() {
    super.initState();
    controller = LogsController();
    subscription = widget.stream.listen(controller.addLog);
  }

  @override
  void didUpdateWidget(covariant StreamLogsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.stream != widget.stream) {
      subscription.cancel();
      controller.value = [];
      subscription = widget.stream.listen(controller.addLog);
    }
  }

  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LogsScreen.controller(
      controller: controller,
      visualDensity: widget.visualDensity,
      colors: widget.colors,
      icons: widget.icons,
    );
  }
}
