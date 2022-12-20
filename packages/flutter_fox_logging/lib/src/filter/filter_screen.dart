import 'package:flutter/material.dart';
import 'package:flutter_fox_logging/flutter_fox_logging.dart';
import 'package:flutter_fox_logging/src/filter/logs_filter.dart';

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
