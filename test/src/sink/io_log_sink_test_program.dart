import 'package:fox_logging/fox_logging.dart';

Future<void> main(List<String> arguments) {
  return IoLogSink(const JsonFormatter()).write(
    const JsonLogRecordParser()(arguments[0]),
  );
}
