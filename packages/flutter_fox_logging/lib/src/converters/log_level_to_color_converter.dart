import 'package:flutter/material.dart';
import 'package:fox_logging/fox_logging.dart';

class LogLevelToColorConverter extends LogLevelConverter<Color?> {
  const LogLevelToColorConverter({
    Color? defaultValue,
    Color? finest,
    Color? finer,
    Color? fine,
    Color? config,
    Color? info,
    Color? warning,
    Color? severe,
    Color? shout,
  }) : super(
          defaultValue: defaultValue,
          finest: finest ?? Colors.grey,
          finer: finer ?? Colors.grey,
          fine: fine,
          config: config ?? Colors.green,
          info: info ?? Colors.blue,
          warning: warning ?? Colors.deepOrange,
          severe: severe ?? Colors.red,
          shout: shout ?? Colors.purple,
        );
}
