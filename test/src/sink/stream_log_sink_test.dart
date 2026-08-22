import 'package:fox_logging/fox_logging.dart';
import 'package:test/test.dart';

import '../../faker_extensions.dart';

void main() {
  late StreamLogSink logSink;

  setUp(() {
    logSink = StreamLogSink();
  });

  group('nameless constructor', () {
    test('should create a single-subscription stream', () {
      // act && assert
      expect(logSink.stream.isBroadcast, isFalse);
    });
  });

  group('broadcast constructor', () {
    test('should create a broadcast stream', () {
      // arrange
      logSink = StreamLogSink.broadcast();

      // act && assert
      expect(logSink.stream.isBroadcast, isTrue);
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

  group('dispose', () {
    test('should close the stream', () async {
      // arrange
      var isDone = false;
      logSink.stream.listen(null, onDone: () => isDone = true);

      // act
      await logSink.dispose();
      await Future.delayed(const Duration(milliseconds: 1));

      // assert
      expect(isDone, isTrue);
    });
  });
}
