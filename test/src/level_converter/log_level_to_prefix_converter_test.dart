import 'package:faker/faker.dart';
import 'package:logging_extensions/src/level_converter/log_level_converter.dart';
import 'package:logging_extensions/src/level_converter/log_level_to_prefix_converter.dart';
import 'package:test/test.dart';

void main() {
  late String? fakeFinest;
  late String? fakeFiner;
  late String? fakeFine;
  late String? fakeConfig;
  late String? fakeInfo;
  late String? fakeWarning;
  late String? fakeSevere;
  late String? fakeShout;
  late String? fakeDefaultValue;

  late LogLevelToPrefixConverter converter;

  setUp(() {
    fakeFinest = faker.lorem.word();
    fakeFiner = faker.lorem.word();
    fakeFine = faker.lorem.word();
    fakeConfig = faker.lorem.word();
    fakeInfo = faker.lorem.word();
    fakeWarning = faker.lorem.word();
    fakeSevere = faker.lorem.word();
    fakeShout = faker.lorem.word();
    fakeDefaultValue = faker.lorem.word();

    converter = LogLevelToPrefixConverter(
      finest: fakeFinest,
      finer: fakeFiner,
      fine: fakeFine,
      config: fakeConfig,
      info: fakeInfo,
      warning: fakeWarning,
      severe: fakeSevere,
      shout: fakeShout,
      defaultValue: fakeDefaultValue,
    );
  });

  test('should be a [LogLevelConverter]', () {
    expect(converter, isA<LogLevelConverter<String>>());
  });

  group('constructor', () {
    test('should set the fields', () {
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
      converter = LogLevelToPrefixConverter();

      // assert
      expect(converter.finest, '[V]');
      expect(converter.finer, '[D]');
      expect(converter.fine, '[F]');
      expect(converter.config, '[C]');
      expect(converter.info, '[I]');
      expect(converter.warning, '[W]');
      expect(converter.severe, '[E]');
      expect(converter.shout, '[WTF]');
      expect(converter.defaultValue, '');
    });
  });
}
