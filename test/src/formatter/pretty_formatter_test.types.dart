part of 'pretty_formatter_test.dart';

class _LogLevelToSymbolConverter extends LogLevelConverter<String> {
  _LogLevelToSymbolConverter()
      : super(
          defaultValue: faker.lorem.word(),
          finest: faker.lorem.word(),
          finer: faker.lorem.word(),
          fine: faker.lorem.word(),
          config: faker.lorem.word(),
          info: faker.lorem.word(),
          warning: faker.lorem.word(),
          severe: faker.lorem.word(),
          shout: faker.lorem.word(),
        );
}

class _LogLevelToPenConverter extends LogLevelConverter<AnsiPen> {
  _LogLevelToPenConverter()
      : super(
          defaultValue: AnsiPen(),
          finest: AnsiPen(),
          finer: AnsiPen(),
          fine: AnsiPen(),
          config: AnsiPen(),
          info: AnsiPen(),
          warning: AnsiPen(),
          severe: AnsiPen(),
          shout: AnsiPen(),
        );
}
