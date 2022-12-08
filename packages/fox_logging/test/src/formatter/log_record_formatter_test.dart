import 'package:fox_logging/fox_logging.dart';
import 'package:test/test.dart';

import '../../faker_extensions.dart';

class _LogRecordFormatter extends LogRecordFormatter {
  const _LogRecordFormatter(this.returnValue);

  final String returnValue;

  @override
  String format(LogRecord logRecord) => returnValue;
}

void main() {
  late String fakeReturnValue;
  late LogRecordFormatter formatter;

  setUp(() {
    fakeReturnValue = faker.lorem.sentence();
    formatter = _LogRecordFormatter(fakeReturnValue);
  });

  group('call', () {
    test('should call format', () {
      // act
      final value = formatter(faker.logRecord());

      // assert
      expect(value, fakeReturnValue);
    });
  });
}
