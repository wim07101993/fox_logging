import 'package:flutter/material.dart';
import 'package:flutter_fox_logging/flutter_fox_logging.dart';
import 'package:log_viewer/file_picker_screen.dart';

final logger = Logger('root');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  hierarchicalLoggingEnabled = true;
  recordStackTraceAtLevel = Level.SEVERE;

  runApp(const MaterialApp(home: FilePickerScreen()));
}
