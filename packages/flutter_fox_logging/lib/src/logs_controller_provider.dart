import 'package:flutter/material.dart';

import 'models/logs_controller.dart';

class LogsControllerProvider extends InheritedWidget {
  const LogsControllerProvider({
    Key? key,
    required Widget child,
    required this.controller,
  }) : super(key: key, child: child);

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
