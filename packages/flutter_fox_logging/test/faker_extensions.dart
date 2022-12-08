import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
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

  Level logLevel() => randomGenerator.element(Level.LEVELS);

  Color color() => Color(faker.randomGenerator.integer(0xFFFFFFFF));

  T? nullOr<T>(T Function() value) {
    return randomGenerator.boolean() ? value() : null;
  }
}
