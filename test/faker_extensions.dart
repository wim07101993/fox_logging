import 'dart:async';
import 'dart:io';

import 'package:faker/faker.dart';
import 'package:logging/logging.dart';

export 'package:faker/faker.dart';

extension FakerExtensions on Faker {
  LogRecord logRecord() {
    return LogRecord(
      logLevel(),
      faker.lorem.sentence(),
      faker.lorem.word(),
      faker.nullOr(() => faker.lorem.sentence()),
      faker.nullOr(() => StackTrace.current),
      faker.nullOr(() => Zone.current),
      faker.nullOr(() => faker.lorem.sentence()),
    );
  }

  FileMode fileMode() {
    return faker.randomGenerator.element([
      FileMode.read,
      FileMode.write,
      FileMode.writeOnlyAppend,
      FileMode.writeOnly,
      FileMode.append,
    ]);
  }

  Level logLevel() => randomGenerator.element(Level.LEVELS);

  T? nullOr<T>(T Function() value) {
    return randomGenerator.boolean() ? value() : null;
  }
}
