import 'package:fox_logging/fox_logging.dart';
import 'package:test/test.dart';

import '../../faker_extensions.dart';

class _LogRecordParser extends LogRecordParser {
  const _LogRecordParser(this.returnValue);

  final LogRecord returnValue;
  Iterable<LogRecord> get listReturnValue => const [];

  @override
  LogRecord parse(String value) => returnValue;

  @override
  Iterable<LogRecord> parseList(String value) => listReturnValue;
}

void main() {
  late LogRecord fakeReturnValue;
  late LogRecordParser parser;

  setUp(() {
    fakeReturnValue = faker.logRecord();
    parser = _LogRecordParser(fakeReturnValue);
  });

  group('call', () {
    test('should call format', () {
      // act
      final value = parser(faker.lorem.sentence());

      // assert
      expect(value, fakeReturnValue);
    });
  });
}
