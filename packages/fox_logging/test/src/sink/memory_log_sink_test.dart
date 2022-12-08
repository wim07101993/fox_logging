import 'package:fox_logging/fox_logging.dart';
import 'package:test/test.dart';

import '../../faker_extensions.dart';

void main() {
  late int fakeBufferSize;

  late MemoryLogSink logSink;

  setUp(() {
    fakeBufferSize = faker.randomGenerator.integer(20);

    logSink = MemoryLogSink.fixedBuffer(bufferSize: fakeBufferSize);
  });

  group('constructor', () {
    test('should create a list with the given buffer-size', () {
      // act
      final logEntries = List.generate(
        fakeBufferSize * 2,
        (i) => faker.logRecord(),
      );
      for (var i = 0; i < logEntries.length; i++) {
        logSink.write(logEntries[i]);
      }

      // assert
      expect(logSink.logRecords.length, fakeBufferSize);
      for (var i = logEntries.length - 1;
          i >= logEntries.length - fakeBufferSize;
          i--) {
        expect(logSink.logRecords, contains(logEntries[i]));
      }
    });

    test('should create a list with infinite size', () {
      // arrange
      logSink = MemoryLogSink.variableBuffer();

      // act
      final logEntries = List.generate(
        fakeBufferSize * 2,
        (i) => faker.logRecord(),
      );
      for (var i = 0; i < logEntries.length; i++) {
        logSink.write(logEntries[i]);
      }

      // assert
      expect(logSink.logRecords.length, fakeBufferSize * 2);
      expect(logSink.logRecords, containsAll(logEntries));
    });
  });

  group('dispose', () {
    test('should empty the list', () async {
      // arrange
      final logRecord = faker.logRecord();
      logSink.write(logRecord);

      // act
      await logSink.dispose();

      // assert
      expect(logSink.logRecords.length, 0);
    });
  });
}
