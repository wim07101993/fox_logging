import 'package:flutter/material.dart';
import 'package:flutter_fox_logging/src/models/logs_controller.dart';

class LogsControllerProvider extends InheritedWidget {
  const LogsControllerProvider({
    super.key,
    required super.child,
    required this.controller,
  });

  factory LogsControllerProvider.builder({
    Key? key,
    required Widget Function(BuildContext context) builder,
    required LogsController controller,
  }) {
    return LogsControllerProvider(
      key: key,
      child: Builder(builder: builder),
      controller: controller,
    );
  }

  final LogsController controller;

  @override
  bool updateShouldNotify(LogsControllerProvider oldWidget) {
    return oldWidget.controller != controller;
  }
}
