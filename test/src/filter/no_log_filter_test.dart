import 'package:fox_logging/fox_logging.dart';
import 'package:test/test.dart';

import '../../faker_extensions.dart';

void main() {
  late NoLogFilter filter;

  setUp(() {
    filter = const NoLogFilter();
  });

  group('shouldLog', () {
    test('should return true', () {
      // act
      final shouldLog = filter.shouldLog(faker.logRecord());

      // assert
      expect(shouldLog, isTrue);
    });
  });
}
