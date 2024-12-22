import 'package:fox_logging/fox_logging.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../faker_extensions.dart';

void main() {
  late DevLogSink sink;

  setUpAll(() {
    registerFallbackValue(LogRecord(Level.ALL, '', ''));
  });

  setUp(() {
    sink = DevLogSink();
  });

  group('write', () {
    late LogRecord fakeLogRecord;

    setUp(() {
      fakeLogRecord = faker.logRecord();
    });

    test('should write the log-record to the dev-log', () async {
      // act
      await sink.write(fakeLogRecord);

      // assert
      // nothing to assert since these logs only show in debug mode
    });
  });
}
