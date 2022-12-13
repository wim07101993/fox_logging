import 'package:flutter/material.dart';
import 'package:flutter_fox_logging/src/fields/fields_screen.dart';
import 'package:flutter_fox_logging/src/filters/filter_screen.dart';
import 'package:flutter_fox_logging/src/models/logs_controller.dart';

class OptionsButton extends StatelessWidget {
  const OptionsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_Option>(
      onSelected: (option) => option.navigate(context),
      itemBuilder: (context) => const [
        PopupMenuItem(value: _Fields(), child: Text('Visible fields')),
        PopupMenuItem(value: _Filter(), child: Text('Filter')),
      ],
    );
  }
}

abstract class _Option {
  Future<void> navigate(BuildContext context);
}

class _Fields implements _Option {
  const _Fields();

  @override
  Future<void> navigate(BuildContext context) {
    final controller = LogsController.of(context);
    return Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => FieldsScreen(controller: controller),
    ));
  }
}

class _Filter implements _Option {
  const _Filter();

  @override
  Future<void> navigate(BuildContext context) {
    final controller = LogsController.of(context);
    return Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => FilterScreen(controller: controller),
    ));
  }
}
