import 'package:fox_logging/fox_logging.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../faker_extensions.dart';
import '../../mocks.dart';

void main() {
  late List<MockLogSink> mockLogSinks;
  late MultiLogSink multiLogSink;

  setUpAll(() {
    registerFallbackValue(faker.logRecord());
  });

  setUp(() {
    mockLogSinks = faker.randomGenerator
        .amount((_) => MockLogSink(), faker.randomGenerator.integer(5, min: 1));

    multiLogSink = MultiLogSink(mockLogSinks);
  });

  group('write', () {
    late LogRecord fakeLogRecord;

    setUp(() {
      fakeLogRecord = faker.logRecord();
    });

    test('should write to all sinks', () async {
      // act
      await multiLogSink.write(fakeLogRecord);

      // assert
      for (final mockLogSink in mockLogSinks) {
        verify(() => mockLogSink.log(fakeLogRecord));
      }
    });

    test('should let each sink apply its own filter', () async {
      // arrange
      final blockedSink = StreamLogSink.broadcast(
        const LogFilter.level(Level.SEVERE),
      );
      final passingSink = StreamLogSink.broadcast();
      multiLogSink = MultiLogSink([blockedSink, passingSink]);
      final logRecord = faker.logRecord(level: Level.INFO);

      LogRecord? blocked;
      LogRecord? passed;
      blockedSink.stream.listen((record) => blocked = record);
      passingSink.stream.listen((record) => passed = record);

      // act
      await multiLogSink.write(logRecord);
      await Future.delayed(const Duration(milliseconds: 1));

      // assert
      expect(blocked, isNull);
      expect(passed, logRecord);
    });
  });

  group('dispose', () {
    test('should dispose all sinks', () async {
      // act
      await multiLogSink.dispose();

      // assert
      for (final mockLogSink in mockLogSinks) {
        verify(mockLogSink.dispose);
      }
    });
  });
}
