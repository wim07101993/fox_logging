import 'package:flutter/material.dart';
import 'package:flutter_fox_logging/src/models/logs_controller.dart';
import 'package:fox_logging/fox_logging.dart';

class LevelFilterSelector extends StatelessWidget {
  const LevelFilterSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = LogsController.of(context);
    final minimumLevelNotifier = controller.filter.minimumLevel;
    final levelsNotifier = controller.visibleLevels;
    return ValueListenableBuilder<Level>(
      valueListenable: minimumLevelNotifier,
      builder: (context, level, oldWidget) {
        return ValueListenableBuilder<List<Level>>(
          valueListenable: levelsNotifier,
          builder: (context, levels, oldWidget) {
            return DropdownButtonFormField<Level>(
              hint: const Text('Level'),
              decoration: const InputDecoration(label: Text('Minimum level')),
              items: levels.map(_menuItem).toList(),
              value: level,
              onChanged: (v) => minimumLevelNotifier.value = v ?? Level.FINEST,
            );
          },
        );
      },
    );
  }

  DropdownMenuItem<Level> _menuItem(Level level) {
    return DropdownMenuItem(
      value: level,
      child: Text(level.name),
    );
  }
}
