import 'package:ansicolor/ansicolor.dart';
import 'package:fox_logging/fox_logging.dart';
import 'package:test/test.dart';

void main() {
  late AnsiPen? fakeFinest;
  late AnsiPen? fakeFiner;
  late AnsiPen? fakeFine;
  late AnsiPen? fakeConfig;
  late AnsiPen? fakeInfo;
  late AnsiPen? fakeWarning;
  late AnsiPen? fakeSevere;
  late AnsiPen? fakeShout;

  late LogLevelToAnsiPenConverter converter;

  setUp(() {
    fakeFinest = AnsiPen();
    fakeFiner = AnsiPen();
    fakeFine = AnsiPen();
    fakeConfig = AnsiPen();
    fakeInfo = AnsiPen();
    fakeWarning = AnsiPen();
    fakeSevere = AnsiPen();
    fakeShout = AnsiPen();

    converter = LogLevelToAnsiPenConverter(
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
    expect(converter, isA<LogLevelConverter<AnsiPen>>());
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
      converter = LogLevelToAnsiPenConverter();

      // assert
      expect(converter.finest?.up, (AnsiPen()..gray(level: 0.5)).up);
      expect(converter.finest?.down, (AnsiPen()..gray(level: 0.5)).down);
      expect(converter.finer?.up, (AnsiPen()..gray(level: 0.75)).up);
      expect(converter.finer?.down, (AnsiPen()..gray(level: 0.75)).down);
      expect(converter.fine?.up, (AnsiPen()..gray()).up);
      expect(converter.fine?.down, (AnsiPen()..gray()).down);
      expect(converter.config?.up, (AnsiPen()..green()).up);
      expect(converter.config?.down, (AnsiPen()..green()).down);
      expect(converter.info?.up, (AnsiPen()..blue()).up);
      expect(converter.info?.down, (AnsiPen()..blue()).down);
      expect(converter.warning?.up, (AnsiPen()..yellow()).up);
      expect(converter.warning?.down, (AnsiPen()..yellow()).down);
      expect(converter.severe?.up, (AnsiPen()..red(bg: true)).up);
      expect(converter.severe?.down, (AnsiPen()..red(bg: true)).down);
      expect(
        converter.shout?.up,
        (AnsiPen()..magenta(bg: true, bold: true)).up,
      );
      expect(
        converter.shout?.down,
        (AnsiPen()..magenta(bg: true, bold: true)).down,
      );
      expect(converter.defaultValue.up, AnsiPen().up);
      expect(converter.defaultValue.down, AnsiPen().down);
    });
  });
}
