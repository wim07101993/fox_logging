import 'package:flutter/material.dart';
import 'package:fox_logging/fox_logging.dart';

class LevelFilterSelector extends StatelessWidget {
  const LevelFilterSelector({
    super.key,
    required this.controller,
  });

  final ValueNotifier<Level> controller;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<Level>(
      hint: const Text('Level'),
      decoration: const InputDecoration(label: Text('Minimum level')),
      items: Level.LEVELS.map(_menuItem).toList(),
      value: controller.value,
      onChanged: (v) => controller.value = v ?? Level.ALL,
    );
  }

  DropdownMenuItem<Level> _menuItem(Level level) {
    return DropdownMenuItem(
      value: level,
      child: Text(level.name),
    );
  }
}
