import 'package:flutter/material.dart';
import 'package:flutter_fox_logging/flutter_fox_logging.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mocks.dart';

void main() {
  late MockIconData? fakeDefault;
  late MockIconData? fakeFinest;
  late MockIconData? fakeFiner;
  late MockIconData? fakeFine;
  late MockIconData? fakeConfig;
  late MockIconData? fakeInfo;
  late MockIconData? fakeWarning;
  late MockIconData? fakeSevere;
  late MockIconData? fakeShout;

  late LogLevelToIconConverter converter;

  setUp(() {
    fakeDefault = MockIconData();
    fakeFinest = MockIconData();
    fakeFiner = MockIconData();
    fakeFine = MockIconData();
    fakeConfig = MockIconData();
    fakeInfo = MockIconData();
    fakeWarning = MockIconData();
    fakeSevere = MockIconData();
    fakeShout = MockIconData();

    converter = LogLevelToIconConverter(
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
    expect(converter, isA<LogLevelConverter<IconData?>>());
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
      converter = const LogLevelToIconConverter();

      // assert
      expect(converter.finest, Icons.code);
      expect(converter.finer, Icons.bug_report);
      expect(converter.fine, null);
      expect(converter.config, Icons.settings);
      expect(converter.info, Icons.info);
      expect(converter.warning, Icons.warning);
      expect(converter.severe, Icons.error);
      expect(converter.shout, Icons.bolt);
      expect(converter.defaultValue, null);
    });
  });
}
