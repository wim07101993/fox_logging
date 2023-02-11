import 'package:fox_logging/fox_logging.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../faker_extensions.dart';
import '../mocks.dart';

void main() {
  late String fakeMessage;
  late String? fakeError;
  late StackTrace? fakeStackTrace;

  late MockLogger mockLogger;

  setUp(() {
    fakeMessage = faker.lorem.sentence();
    fakeError = faker.nullOr(() => faker.lorem.sentence());
    fakeStackTrace = faker.nullOr(() => StackTrace.current);
    mockLogger = MockLogger();
  });

  test('log verbose', () {
    // act
    mockLogger.v(fakeMessage, fakeError, fakeStackTrace);

    // assert
    verify(() => mockLogger.finest(fakeMessage, fakeError, fakeStackTrace));
  });

  test('log debug', () {
    // act
    mockLogger.d(fakeMessage, fakeError, fakeStackTrace);

    // assert
    verify(() => mockLogger.finer(fakeMessage, fakeError, fakeStackTrace));
  });

  test('log fine', () {
    // act
    mockLogger.f(fakeMessage, fakeError, fakeStackTrace);

    // assert
    verify(() => mockLogger.fine(fakeMessage, fakeError, fakeStackTrace));
  });

  test('log config', () {
    // act
    mockLogger.c(fakeMessage, fakeError, fakeStackTrace);

    // assert
    verify(() => mockLogger.config(fakeMessage, fakeError, fakeStackTrace));
  });

  test('log info', () {
    // act
    mockLogger.i(fakeMessage, fakeError, fakeStackTrace);

    // assert
    verify(() => mockLogger.info(fakeMessage, fakeError, fakeStackTrace));
  });

  test('log warning', () {
    // act
    mockLogger.w(fakeMessage, fakeError, fakeStackTrace);

    // assert
    verify(() => mockLogger.warning(fakeMessage, fakeError, fakeStackTrace));
  });

  test('log error', () {
    // act
    mockLogger.e(fakeMessage, fakeError, fakeStackTrace);

    // assert
    verify(() => mockLogger.severe(fakeMessage, fakeError, fakeStackTrace));
  });

  test('log wtf', () {
    // act
    mockLogger.wtf(fakeMessage, fakeError, fakeStackTrace);

    // assert
    verify(() => mockLogger.shout(fakeMessage, fakeError, fakeStackTrace));
  });
}
