import 'dart:async';
import 'dart:io';

import 'package:faker/faker.dart';
import 'package:logging/logging.dart';

export 'package:faker/faker.dart';

extension FakerExtensions on Faker {
  LogRecord logRecord({
    Level? level,
    bool? generateStackTrace,
    bool? generateError,
    bool? generateZone,
    bool? generateObject,
  }) {
    return LogRecord(
      level ?? logLevel(),
      faker.lorem.sentence(),
      faker.lorem.word(),
      faker.maybeGenerate(
        () => faker.lorem.sentence(),
        shouldGenerate: generateError,
      ),
      faker.maybeGenerate(
        () => StackTrace.current,
        shouldGenerate: generateStackTrace,
      ),
      faker.maybeGenerate(() => Zone.current, shouldGenerate: generateZone),
      faker.maybeGenerate(
        () => faker.lorem.sentence(),
        shouldGenerate: generateObject,
      ),
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

  T? maybeGenerate<T>(
    T Function() value, {
    bool? shouldGenerate,
  }) {
    return shouldGenerate ?? randomGenerator.boolean() ? value() : null;
  }
}
