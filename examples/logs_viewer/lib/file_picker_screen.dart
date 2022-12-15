import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fox_logging/flutter_fox_logging.dart';

class FilePickerScreen extends StatelessWidget {
  const FilePickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () => pickFiles(context),
              child: const Text('Select log file'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> pickFiles(BuildContext context) async {
    final navigator = Navigator.of(context);
    final result = await FilePicker.platform.pickFiles(
      dialogTitle: 'Select log file',
    );
    if (result == null || result.files.isEmpty) {
      return;
    }

    final logRecordLists = await Future.wait(
      result.paths.whereType<String>().map(tryReadLogFile),
    );

    final logs = logRecordLists.expand((list) => list).toList()
      ..sort((a, b) => a.time.compareTo(b.time));

    navigator.push(
      MaterialPageRoute(
        builder: (context) => LogsScreen.controller(
          controller: LogsController(logs: logs),
        ),
      ),
    );
  }

  Future<List<LogRecord>> tryReadLogFile(String path) async {
    try {
      final contents = await File(path).readAsString();
      const parser = JsonLogRecordParser();
      return parser.parseList(contents).toList(growable: false);
    } catch (e) {
      return const [];
    }
  }
}
