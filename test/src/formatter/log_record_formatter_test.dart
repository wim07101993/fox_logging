import 'package:fox_logging/fox_logging.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../faker_extensions.dart';

class _MockLogRecordFormatter extends Mock implements LogRecordFormatter {}

class _LogRecordFormatter extends LogRecordFormatter {
  const _LogRecordFormatter(this._format);

  final String Function(LogRecord logRecord) _format;

  @override
  String format(LogRecord logRecord) => _format(logRecord);
}

void main() {
  late _MockLogRecordFormatter mockFormatter;
  late LogRecordFormatter formatter;

  setUpAll(() {
    registerFallbackValue(LogRecord(const Level('', 0), '', ''));
  });

  setUp(() {
    mockFormatter = _MockLogRecordFormatter();
    formatter = _LogRecordFormatter(mockFormatter.format);
  });

  group('call', () {
    test('should call format', () {
      // arrange
      final fakeReturnValue = faker.lorem.sentence();
      when(() => mockFormatter.format(any())).thenReturn(fakeReturnValue);

      // act
      final value = formatter(faker.logRecord());

      // assert
      expect(value, fakeReturnValue);
    });
  });

  group('formatList', () {
    test('should call format for all the records', () {
      // arrange
      final logRecord1 = faker.logRecord();
      final logRecord2 = faker.logRecord();
      final logRecord3 = faker.logRecord();

      final fakeReturnValue1 = faker.lorem.sentence();
      final fakeReturnValue2 = faker.lorem.sentence();
      final fakeReturnValue3 = faker.lorem.sentence();

      when(() => mockFormatter.format(logRecord1)).thenReturn(fakeReturnValue1);
      when(() => mockFormatter.format(logRecord2)).thenReturn(fakeReturnValue2);
      when(() => mockFormatter.format(logRecord3)).thenReturn(fakeReturnValue3);

      // act
      final value = formatter.formatList([logRecord1, logRecord2, logRecord3]);

      // assert
      expect(
        value,
        '$fakeReturnValue1\r\n'
        '$fakeReturnValue2\r\n'
        '$fakeReturnValue3',
      );
    });
  });
}
