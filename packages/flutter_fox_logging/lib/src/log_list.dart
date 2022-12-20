import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fox_logging/src/converters/log_level_to_color_converter.dart';
import 'package:flutter_fox_logging/src/converters/log_level_to_icon_converter.dart';
import 'package:flutter_fox_logging/src/field_visibilities.dart';
import 'package:flutter_fox_logging/src/log_list_item.dart';
import 'package:fox_logging/fox_logging.dart';

class LogList extends StatefulWidget {
  const LogList({
    super.key,
    required this.logs,
    this.visibleFields,
    this.colors = const LogLevelToColorConverter(),
    this.icons = const LogLevelToIconConverter(),
    this.visualDensity = const VisualDensity(vertical: -4),
    this.detailScreenBuilder,
  });

  final Converter<Level, Color?> colors;
  final Converter<Level, IconData?> icons;
  final VisualDensity visualDensity;
  final Widget Function(LogRecord log)? detailScreenBuilder;
  final List<LogRecord> logs;
  final ValueListenable<LogFieldVisibilities>? visibleFields;

  @override
  State<LogList> createState() => _LogListState();
}

class _LogListState extends State<LogList> {
  final scrollController = ScrollController();
  ValueNotifier<LogFieldVisibilities>? _visibleFields;

  ValueListenable<LogFieldVisibilities> get visibleFields {
    final widgetVisibleFields = widget.visibleFields;
    if (widgetVisibleFields != null) {
      return widgetVisibleFields;
    }
    return _visibleFields ??= ValueNotifier(const LogFieldVisibilities());
  }

  @override
  void didUpdateWidget(covariant LogList oldWidget) {
    if (_visibleFields != null && widget.visibleFields != null) {
      _visibleFields?.dispose();
      _visibleFields = null;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _visibleFields?.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (scrollController.positions.isNotEmpty &&
        scrollController.position.hasContentDimensions &&
        scrollController.offset == scrollController.position.maxScrollExtent) {
      scrollToBottom();
    }
    return ListView.builder(
      controller: scrollController,
      itemCount: widget.logs.length,
      itemBuilder: (context, i) {
        final logRecord = widget.logs[i];
        return LogListItem(
          logRecord: widget.logs[i],
          icon: widget.icons.convert(logRecord.level),
          color: widget.colors.convert(logRecord.level),
          visualDensity: widget.visualDensity,
          detailScreenBuilder: widget.detailScreenBuilder,
          visibleFields: visibleFields,
        );
      },
    );
  }

  Future scrollToBottom() {
    if (scrollController.positions.isEmpty) {
      return Future.value();
    }
    return Future.delayed(
      const Duration(milliseconds: 1),
      () => scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      ),
    );
  }
}
