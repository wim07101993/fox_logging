import 'package:fox_logging/fox_logging.dart';
import 'package:test/test.dart';

import '../../faker_extensions.dart';

void main() {
  group('constructors', () {
    test('none should return a [NoLogFilter]', () {
      // act
      const filter = LogFilter.none();

      // assert
      expect(filter, isA<NoLogFilter>());
    });

    test('level should return a [LogLevelFilter]', () {
      // arrange
      final level = faker.logLevel();

      // act
      final filter = LogFilter.level(level);

      // assert
      expect(filter, isA<LogLevelFilter>());
    });
  });
}
