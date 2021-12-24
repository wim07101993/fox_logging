import 'package:logging_extensions/logging_extensions.dart';
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
        verify(() => mockLogSink.write(fakeLogRecord));
      }
    });
  });
}
