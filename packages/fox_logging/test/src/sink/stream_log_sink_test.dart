import 'package:fox_logging/src/sink/stream_log_sink.dart';
import 'package:logging/logging.dart';
import 'package:test/test.dart';

import '../../faker_extensions.dart';

void main() {
  late StreamLogSink logSink;

  setUp(() {
    logSink = StreamLogSink();
  });

  group('nameless constructor', () {
    test('should create a stream controller', () async {
      // act && assert
      final _ = logSink.stream;
    });
  });

  group('broadcast constructor', () {
    test('should create a stream controller', () async {
      // act && assert
      final _ = logSink.stream;
    });

    test('should be possible to listen multiple times', () async {
      // arrange
      logSink = StreamLogSink.broadcast();
      LogRecord? receivedRecord1;
      LogRecord? receivedRecord2;
      final logRecord = faker.logRecord();

      // act
      final stream1 = logSink.stream;
      final stream2 = logSink.stream;
      stream1.listen((record) => receivedRecord1 = record);
      stream2.listen((record) => receivedRecord2 = record);
      await logSink.write(logRecord);

      // assert
      expect(receivedRecord1, logRecord);
      expect(receivedRecord2, logRecord);
    });
  });

  group('write', () {
    test('should add the log-record to the stream', () async {
      // arrange
      logSink = StreamLogSink();
      LogRecord? receivedRecord;
      final stream = logSink.stream;
      stream.listen((record) => receivedRecord = record);
      var logRecord = faker.logRecord();

      // act
      await logSink.write(logRecord);

      // assert
      expect(receivedRecord, logRecord);

      // arrange
      logRecord = faker.logRecord();

      // act
      await logSink.write(logRecord);

      // assert
      expect(receivedRecord, logRecord);
    });
  });
}
