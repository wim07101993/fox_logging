import 'package:fox_logging/fox_logging.dart';
import 'package:test/test.dart';

import '../../faker_extensions.dart';

void main() {
  late Level fakeLevel;

  late LogLevelFilter filter;

  setUp(() {
    fakeLevel = faker.logLevel();

    filter = LogLevelFilter(fakeLevel);
  });

  group('shouldLog', () {
    test(
      'should return false if level of logRecord is lower than filter level',
      () {
        // arrange
        final logRecord = faker.logRecord(
          level: Level(faker.lorem.word(), fakeLevel.value - 1),
        );

        // act
        final shouldLog = filter.shouldLog(logRecord);

        // arrange
        expect(shouldLog, isFalse);
      },
    );

    test(
      'should return true if level of logRecord is equal to filter level',
      () {
        // arrange
        final logRecord = faker.logRecord(
          level: Level(faker.lorem.word(), fakeLevel.value),
        );

        // act
        final shouldLog = filter.shouldLog(logRecord);

        // arrange
        expect(shouldLog, isTrue);
      },
    );

    test(
      'should return true if level of logRecord is higher than filter level',
      () {
        // arrange
        final logRecord = faker.logRecord(
          level: Level(faker.lorem.word(), fakeLevel.value + 1),
        );

        // act
        final shouldLog = filter.shouldLog(logRecord);

        // arrange
        expect(shouldLog, isTrue);
      },
    );
  });
}
