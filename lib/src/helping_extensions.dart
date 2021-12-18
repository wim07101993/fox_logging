import 'package:logging/logging.dart';
import 'package:logging_extensions/logging_extensions.dart';
import 'package:logging_extensions/src/sinks/log_sink.dart';

extension LoggingExtensionsListExtensions<T> on Iterable<T> {
  Iterable<TOut> mapMany<TOut>(Iterable<TOut> Function(T) selector) sync* {
    for (final outer in this) {
      for (final inner in selector(outer)) {
        yield inner;
      }
    }
  }
}

extension LogStreamExtensions on Stream<LogRecord> {
  Stream<String> format(LogRecordFormatter formatter) {
    return map(formatter.format);
  }

  void sink(LogSink sink) {}
}
