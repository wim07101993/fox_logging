import 'package:flutter/material.dart';
import 'package:flutter_fox_logging/src/filter/logs_filter.dart';
import 'package:flutter_fox_logging/src/logs_controller/logs_controller.dart';

class FilterScreen extends StatelessWidget {
  const FilterScreen({
    super.key,
    required this.controller,
  });

  final LogsController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Filter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: LogsFilter(controller: controller),
      ),
    );
  }
}
