import 'package:fox_logging/fox_logging.dart';
import 'package:fox_logging/src/sink/io_log_sink.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:test_process/test_process.dart';

import '../../faker_extensions.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(LogRecord(Level.ALL, '', ''));
  });

  group('write', () {
    test('should format the log-record', () async {
      // arrange
      final LogRecordFormatter formatter = _MockFormatter();
      final fakeLogRecord = faker.logRecord();
      final lines =
          faker.randomGenerator.amount((i) => faker.lorem.sentence(), 10);
      when(() => formatter(any())).thenReturn(lines.join("\r\n"));
      final sink = IoLogSink(formatter);

      // act
      await sink.write(fakeLogRecord);

      // assert
      verify(() => formatter(fakeLogRecord));
    });

    test(
      'should write the lines of logs with level < SEVERE to stdout',
      () async {
        // arrange
        final fakeLogRecord = faker.logRecord(
          level: faker.logLevel(
            value: faker.randomGenerator.integer(Level.SEVERE.value - 1),
          ),
        );
        final fakeJsonLogRecord = const JsonFormatter()(fakeLogRecord);

        // act
        final process = await TestProcess.start(
          'dart',
          [
            'run',
            'test/src/sink/io_log_sink_test_program.dart',
            fakeJsonLogRecord,
          ],
        );

        // assert
        await expectLater(process.stdout, emits(fakeJsonLogRecord));
        await process.shouldExit(0);
      },
    );

    test(
      'should write the lines of logs with level >= SEVERE to stderr',
      () async {
        // arrange
        final fakeLogRecord = faker.logRecord(
          level: faker.logLevel(
            value: faker.randomGenerator.integer(
              Level.OFF.value,
              min: Level.SEVERE.value,
            ),
          ),
        );
        final fakeJsonLogRecord = const JsonFormatter()(fakeLogRecord);

        // act
        final process = await TestProcess.start(
          'dart',
          [
            'run',
            'test/src/sink/io_log_sink_test_program.dart',
            fakeJsonLogRecord,
          ],
        );

        // assert
        await expectLater(process.stderr, emits(fakeJsonLogRecord));
        await process.shouldExit(0);
      },
    );
  });
}

class _MockFormatter extends Mock implements LogRecordFormatter {}
