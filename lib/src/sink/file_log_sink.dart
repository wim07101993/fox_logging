import 'dart:convert';
import 'dart:io';

import 'package:logging/logging.dart';
import 'package:logging_extensions/src/formatter/log_record_formatter.dart';
import 'package:logging_extensions/src/sink/io_log_sink.dart';

/// [IOLogSink] which writes logs to a file.
class FileLogSink extends IOLogSink {
  /// Constructs a [FileLogSink].
  ///
  /// [file] wille be opened in mode [fileMode] and be written to in the given
  /// [encoding] using the [formatter] to convert [LogRecord] to a [String].
  ///
  /// A sink is created using [file] and closed when the [dispose] method is
  /// called.
  FileLogSink({
    required File file,
    required LogRecordFormatter formatter,
    FileMode fileMode = FileMode.writeOnlyAppend,
    Encoding encoding = utf8,
  }) : super(
          sink: file.openWrite(mode: fileMode, encoding: encoding),
          formatter: formatter,
        );

  /// Disposes the the opened file and subscriptions to the log streams.
  @override
  Future<void> dispose() async {
    await super.dispose();
    await sink.close();
  }
}
