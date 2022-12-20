import 'package:flutter/material.dart';
import 'package:flutter_fox_logging/src/field_visibilities.dart';
import 'package:flutter_fox_logging/src/fields_screen.dart';
import 'package:flutter_fox_logging/src/filter/filter_screen.dart';
import 'package:flutter_fox_logging/src/logs_controller.dart';

class OptionsButton extends StatelessWidget {
  const OptionsButton({
    super.key,
    required this.controller,
    required this.visibleFields,
  });

  final LogsController controller;
  final ValueNotifier<LogFieldVisibilities> visibleFields;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_Option>(
      onSelected: (option) => option.navigate(context),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: _Fields(fieldVisibilities: visibleFields),
          child: const Text('Visible fields'),
        ),
        PopupMenuItem(
          value: _Filter(controller: controller),
          child: const Text('Filter'),
        ),
      ],
    );
  }
}

abstract class _Option {
  Future<void> navigate(BuildContext context);
}

class _Fields implements _Option {
  const _Fields({
    required this.fieldVisibilities,
  });

  final ValueNotifier<LogFieldVisibilities> fieldVisibilities;

  @override
  Future<void> navigate(BuildContext context) {
    return Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => FieldsScreen(controller: fieldVisibilities),
    ));
  }
}

class _Filter implements _Option {
  const _Filter({
    required this.controller,
  });

  final LogsController controller;

  @override
  Future<void> navigate(BuildContext context) {
    return Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => FilterScreen(controller: controller),
    ));
  }
}
