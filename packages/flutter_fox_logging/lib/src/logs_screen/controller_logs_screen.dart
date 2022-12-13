import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_fox_logging/flutter_fox_logging.dart';
import 'package:flutter_fox_logging/src/filters/search_button.dart';
import 'package:flutter_fox_logging/src/options_button.dart';

class ControllerLogsScreen extends StatelessWidget implements LogsScreen {
  const ControllerLogsScreen({
    super.key,
    required this.controller,
    this.colors = const LogLevelToColorConverter(),
    this.icons = const LogLevelToIconConverter(),
    this.visualDensity = const VisualDensity(horizontal: 0, vertical: -4),
  });

  final LogsController controller;
  final Converter<Level, Color?> colors;
  final Converter<Level, IconData?> icons;
  final VisualDensity visualDensity;

  @override
  Widget build(BuildContext context) {
    return LogsControllerProvider.builder(
      controller: controller,
      builder: (context) => Scaffold(
        appBar: AppBar(
          leading: const BackButton(),
          actions: const [
            SearchButton(),
            OptionsButton(),
          ],
        ),
        body: Logs(
          colors: colors,
          icons: icons,
          visualDensity: visualDensity,
        ),
      ),
    );
  }
}
