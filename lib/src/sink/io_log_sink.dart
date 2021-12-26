import 'dart:async';
import 'dart:io';

import 'package:logging/logging.dart';
import 'package:logging_extensions/src/formatter/log_record_formatter.dart';
import 'package:logging_extensions/src/sink/log_sink.dart';

/// Writes logs to an [IOSink].
class IOLogSink extends LogSink {
  /// Uses [sink] to write logs to using the given [formatter].
  ///
  /// When the [dispose] method is called, the current buffer of [sink] will
  /// be flushed, but the [sink] will not be closed.
  IOLogSink({
    required this.sink,
    required this.formatter,
  });

  /// The sink to which the logs are written. (is not closed in this class)
  final IOSink sink;

  /// The formatter used to format the logs before writing them to the sink.
  final LogRecordFormatter formatter;

  /// Writes a [logRecord] to the [sink] using the [formatter].
  ///
  /// Always flushes at the end.
  @override
  Future<void> write(LogRecord logRecord) {
    final formatted = formatter.format(logRecord);
    sink.writeln(formatted);
    return sink.flush();
  }

  /// Flushes [sink] but does not dispose it.
  @override
  Future<void> dispose() async {
    await sink.flush();
    return super.dispose();
  }
}
