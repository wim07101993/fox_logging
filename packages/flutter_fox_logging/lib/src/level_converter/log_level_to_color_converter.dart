import 'package:flutter/material.dart';
import 'package:fox_logging/fox_logging.dart';

class LogLevelToColorConverter extends LogLevelConverter<Color?> {
  const LogLevelToColorConverter({
    super.defaultValue,
    Color? finest,
    Color? finer,
    super.fine,
    Color? config,
    Color? info,
    Color? warning,
    Color? severe,
    Color? shout,
  }) : super(
          finest: finest ?? Colors.grey,
          finer: finer ?? Colors.grey,
          config: config ?? Colors.green,
          info: info ?? Colors.blue,
          warning: warning ?? Colors.deepOrange,
          severe: severe ?? Colors.red,
          shout: shout ?? Colors.purple,
        );
}
