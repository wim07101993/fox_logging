import 'package:flutter/material.dart';
import 'package:fox_logging/fox_logging.dart';

class LogLevelToIconConverter extends LogLevelConverter<IconData?> {
  const LogLevelToIconConverter({
    super.defaultValue,
    IconData? finest,
    IconData? finer,
    super.fine,
    IconData? config,
    IconData? info,
    IconData? warning,
    IconData? severe,
    IconData? shout,
  }) : super(
          finest: finest ?? Icons.code,
          finer: finer ?? Icons.bug_report,
          config: config ?? Icons.settings,
          info: info ?? Icons.info,
          warning: warning ?? Icons.warning,
          severe: severe ?? Icons.error,
          shout: shout ?? Icons.bolt,
        );
}
