import 'package:flutter/material.dart';
import 'package:flutter_fox_logging/src/filters/level_filter_selector.dart';
import 'package:flutter_fox_logging/src/filters/logger_selector.dart';
import 'package:flutter_fox_logging/src/logs_controller_provider.dart';
import 'package:flutter_fox_logging/src/models/logs_controller.dart';

class FilterScreen extends StatelessWidget {
  const FilterScreen({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final LogsController controller;

  @override
  Widget build(BuildContext context) {
    return LogsControllerProvider.builder(
      controller: controller,
      builder: (context) => Scaffold(
        appBar: AppBar(
          leading: const BackButton(),
          title: const Text('Filter'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(children: const [
            LevelFilterSelector(),
            SizedBox(height: 16),
            LoggerSelector(),
          ]),
        ),
      ),
    );
  }
}
