import 'package:fox_logging/fox_logging.dart';
import 'package:fox_logging/src/sink/io_log_sink.dart';

Future<void> main(List<String> arguments) {
  return IoLogSink(const JsonFormatter()).write(
    const JsonLogRecordParser()(arguments[0]),
  );
}
