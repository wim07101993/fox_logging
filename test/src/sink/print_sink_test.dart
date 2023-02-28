import 'package:fox_logging/fox_logging.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../faker_extensions.dart';
import '../../print_tests.dart';

void main() {
  late LogRecordFormatter formatter;
  late List<String> lines;

  // ignore: deprecated_member_use_from_same_package
  late PrintSink sink;

  setUpAll(() {
    registerFallbackValue(LogRecord(Level.ALL, '', ''));
  });

  setUp(() {
    formatter = _MockFormatter();
    lines = faker.randomGenerator.amount((i) => faker.lorem.sentence(), 10);

    when(() => formatter.format(any())).thenReturn(lines.join("\r\n"));

    // ignore: deprecated_member_use_from_same_package
    sink = PrintSink(formatter);
  });

  group('write', () {
    late LogRecord fakeLogRecord;

    setUp(() {
      fakeLogRecord = faker.logRecord();
    });

    test('should format the log-record', () async {
      // act
      await sink.write(fakeLogRecord);

      // assert
      verify(() => formatter.format(fakeLogRecord));
    });

    testWithPrint(
      'should print the lines from the formatted output',
      // act
      () async => sink.write(fakeLogRecord),
      // assert
      (prints) => expect(prints, lines),
    );
  });
}

class _MockFormatter extends Mock implements LogRecordFormatter {}
