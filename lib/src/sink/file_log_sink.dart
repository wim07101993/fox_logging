import 'dart:convert';
import 'dart:io';

import 'package:logging_extensions/src/formatter/log_record_formatter.dart';
import 'package:logging_extensions/src/sink/io_log_sink.dart';

class FileLogSink extends IOLogSink {
  FileLogSink({
    required File file,
    required LogRecordFormatter formatter,
    FileMode fileMode = FileMode.writeOnlyAppend,
    Encoding encoding = utf8,
  }) : super(
          sink: file.openWrite(mode: fileMode, encoding: encoding),
          formatter: formatter,
        );

  @override
  Future<void> dispose() async {
    await super.dispose();
    await sink.close();
  }
}
