import 'package:flutter/material.dart';
import 'package:flutter_fox_logging/flutter_fox_logging.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../faker_extensions.dart';

void main() {
  late Color? fakeDefault;
  late Color? fakeFinest;
  late Color? fakeFiner;
  late Color? fakeFine;
  late Color? fakeConfig;
  late Color? fakeInfo;
  late Color? fakeWarning;
  late Color? fakeSevere;
  late Color? fakeShout;

  late LogLevelToColorConverter converter;

  setUp(() {
    fakeDefault = faker.color as Color?;
    fakeFinest = faker.color as Color?;
    fakeFiner = faker.color as Color?;
    fakeFine = faker.color as Color?;
    fakeConfig = faker.color as Color?;
    fakeInfo = faker.color as Color?;
    fakeWarning = faker.color as Color?;
    fakeSevere = faker.color as Color?;
    fakeShout = faker.color as Color?;

    converter = LogLevelToColorConverter(
      defaultValue: fakeDefault,
      finest: fakeFinest,
      finer: fakeFiner,
      fine: fakeFine,
      config: fakeConfig,
      info: fakeInfo,
      warning: fakeWarning,
      severe: fakeSevere,
      shout: fakeShout,
    );
  });

  test('should be a [LogLevelConverter]', () {
    expect(converter, isA<LogLevelConverter<Color?>>());
  });

  group('constructor', () {
    test('should set the fields', () {
      expect(converter.defaultValue, fakeDefault);
      expect(converter.finest, fakeFinest);
      expect(converter.finer, fakeFiner);
      expect(converter.fine, fakeFine);
      expect(converter.config, fakeConfig);
      expect(converter.info, fakeInfo);
      expect(converter.warning, fakeWarning);
      expect(converter.severe, fakeSevere);
      expect(converter.shout, fakeShout);
    });

    test('should set values to defaults if not given', () {
      // act
      converter = const LogLevelToColorConverter();

      // assert
      expect(converter.finest, Colors.grey);
      expect(converter.finer, Colors.grey);
      expect(converter.fine, null);
      expect(converter.config, Colors.green);
      expect(converter.info, Colors.blue);
      expect(converter.warning, Colors.deepOrange);
      expect(converter.severe, Colors.red);
      expect(converter.shout, Colors.purple);
      expect(converter.defaultValue, null);
    });
  });
}
