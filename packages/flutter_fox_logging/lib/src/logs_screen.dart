import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_fox_logging/src/field_visibilities.dart';
import 'package:flutter_fox_logging/src/filter/search_button.dart';
import 'package:flutter_fox_logging/src/level_converter/log_level_to_color_converter.dart';
import 'package:flutter_fox_logging/src/level_converter/log_level_to_icon_converter.dart';
import 'package:flutter_fox_logging/src/listenable_builder.dart';
import 'package:flutter_fox_logging/src/log_list.dart';
import 'package:flutter_fox_logging/src/logs_controller/logs_controller.dart';
import 'package:flutter_fox_logging/src/options_button.dart';
import 'package:fox_logging/fox_logging.dart';

class LogsScreen extends StatefulWidget {
  const LogsScreen({
    super.key,
    required this.controller,
    this.visibleFields,
    this.colors = const LogLevelToColorConverter(),
    this.icons = const LogLevelToIconConverter(),
    this.visualDensity = const VisualDensity(vertical: -4),
  });

  final LogsController controller;
  final ValueNotifier<LogFieldVisibilities>? visibleFields;
  final Converter<Level, Color?> colors;
  final Converter<Level, IconData?> icons;
  final VisualDensity visualDensity;

  @override
  State<LogsScreen> createState() => _LogsScreenState();
}

class _LogsScreenState extends State<LogsScreen> {
  ValueNotifier<LogFieldVisibilities>? _visibleFields;

  ValueNotifier<LogFieldVisibilities> get visibleFields {
    final widgetVisibleFields = widget.visibleFields;
    if (widgetVisibleFields != null) {
      return widgetVisibleFields;
    }
    return _visibleFields ??= ValueNotifier(const LogFieldVisibilities());
  }

  @override
  void didUpdateWidget(covariant LogsScreen oldWidget) {
    if (_visibleFields != null && widget.visibleFields != null) {
      _visibleFields?.dispose();
      _visibleFields = null;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _visibleFields?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        actions: [
          SearchButton(logs: widget.controller),
          OptionsButton(
            controller: widget.controller,
            visibleFields: visibleFields,
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: widget.controller,
        builder: (context) => LogList(
          colors: widget.colors,
          icons: widget.icons,
          visualDensity: widget.visualDensity,
          logs: widget.controller.value.toList(growable: false),
          visibleFields: visibleFields,
        ),
      ),
    );
  }
}
