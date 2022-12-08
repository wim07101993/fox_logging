import 'package:faker/faker.dart';
import 'package:fox_logging/fox_logging.dart';
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
  late String? fakeAll;
  late String? fakeOff;
  late String fakeDefault;

  late LogLevelConverter<String?> converter;

  setUp(() {
    fakeFinest = faker.lorem.word();
    fakeFiner = faker.lorem.word();
    fakeFine = faker.lorem.word();
    fakeConfig = faker.lorem.word();
    fakeInfo = faker.lorem.word();
    fakeWarning = faker.lorem.word();
    fakeSevere = faker.lorem.word();
    fakeShout = faker.lorem.word();
    fakeAll = faker.lorem.word();
    fakeOff = faker.lorem.word();
    fakeDefault = faker.lorem.word();

    converter = LogLevelConverter(
      finest: fakeFinest,
      finer: fakeFiner,
      fine: fakeFine,
      config: fakeConfig,
      info: fakeInfo,
      warning: fakeWarning,
      severe: fakeSevere,
      shout: fakeShout,
      all: fakeAll,
      off: fakeOff,
      defaultValue: fakeDefault,
    );
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
      expect(converter.all, fakeAll);
      expect(converter.off, fakeOff);
      expect(converter.defaultValue, fakeDefault);
    });
  });

  group('convert', () {
    test('should return the value corresponding with finest', () {
      expect(converter.convert(Level.FINEST), fakeFinest);
    });

    test('should return the value corresponding with finer', () {
      expect(converter.convert(Level.FINER), fakeFiner);
    });

    test('should return the value corresponding with fine', () {
      expect(converter.convert(Level.FINE), fakeFine);
    });

    test('should return the value corresponding with config', () {
      expect(converter.convert(Level.CONFIG), fakeConfig);
    });

    test('should return the value corresponding with info', () {
      expect(converter.convert(Level.INFO), fakeInfo);
    });

    test('should return the value corresponding with warning', () {
      expect(converter.convert(Level.WARNING), fakeWarning);
    });

    test('should return the value corresponding with severe', () {
      expect(converter.convert(Level.SEVERE), fakeSevere);
    });

    test('should return the value corresponding with shout', () {
      expect(converter.convert(Level.SHOUT), fakeShout);
    });

    test('should return the value corresponding with all', () {
      expect(converter.convert(Level.ALL), fakeAll);
    });

    test('should return the value corresponding with off', () {
      expect(converter.convert(Level.OFF), fakeOff);
    });

    group('with only a default value', () {
      setUp(() {
        converter = LogLevelConverter(defaultValue: fakeDefault);
      });

      for (final level in Level.LEVELS) {
        test('should return the default value when $level', () {
          expect(converter.convert(level), fakeDefault);
        });
      }
    });
  });
}
