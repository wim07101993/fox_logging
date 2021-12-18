import 'dart:convert';
import 'dart:io';

import 'package:logging_extensions/src/formatter/log_record_formatter.dart';
import 'package:logging_extensions/src/sinks/io_sink.dart';

class FileSink extends IOLogSink {
  FileSink({
    required File file,
    required LogRecordFormatter formatter,
    FileMode fileMode = FileMode.writeOnlyAppend,
    Encoding encoding = utf8,
  }) : super(
          sink: file.openWrite(mode: fileMode, encoding: encoding),
          formatter: formatter,
        );

  FileSink.fromPath({
    required String path,
    required LogRecordFormatter formatter,
    FileMode fileMode = FileMode.writeOnlyAppend,
    Encoding encoding = utf8,
  }) : super(
          sink: File(path).openWrite(mode: fileMode, encoding: encoding),
          formatter: formatter,
        );

  @override
  Future<void> dispose() async {
    await sink.close();
    return super.dispose();
  }
}
