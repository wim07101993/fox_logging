import 'dart:async';

import 'package:fox_logging/fox_logging.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../faker_extensions.dart';
import '../../mocks.dart';

void main() {
  late _MockLogWriter mockWriter;
  late _MockLogFilter mockFilter;

  late LogSinkMixin logSink;

  setUpAll(() {
    registerFallbackValue(faker.logRecord());
  });

  setUp(() {
    mockWriter = _MockLogWriter();
    mockFilter = _MockLogFilter();

    when(() => mockFilter.shouldLog(any())).thenReturn(true);

    logSink = _LogSink(mockWriter, mockFilter);
  });

  group('listenTo', () {
    late StreamController<LogRecord> streamController;

    setUp(() {
      streamController = StreamController();
    });

    tearDown(() {
      logSink.dispose();
    });

    test('should add listener which writes when a new log-record is emitted',
        () async {
      // act 1
      logSink.listenTo(streamController.stream);

      // assert
      for (var i = 0; i < 3; i++) {
        final record = faker.logRecord();
        streamController.add(record);
        await Future.delayed(const Duration(milliseconds: 1));
        verify(() => mockWriter.write(record));
      }
    });

    test('should not write logs when the filter blocks them', () async {
      // arrange
      when(() => mockFilter.shouldLog(any())).thenReturn(false);
      logSink.listenTo(streamController.stream);
      final record = faker.logRecord();

      // act
      streamController.add(record);

      // assert
      await Future.delayed(const Duration(milliseconds: 1));
      verifyNoMoreInteractions(mockWriter);
    });
  });

  group('dispose', () {
    late MockStreamSubscription<LogRecord> mockSubscription1;
    late MockStreamSubscription<LogRecord> mockSubscription2;
    late MockStreamSubscription<LogRecord> mockSubscription3;

    late Stream<LogRecord> mockStream1;
    late Stream<LogRecord> mockStream2;
    late Stream<LogRecord> mockStream3;

    setUp(() {
      mockSubscription1 = MockStreamSubscription();
      mockSubscription2 = MockStreamSubscription();
      mockSubscription3 = MockStreamSubscription();

      mockStream1 = MockStream();
      mockStream2 = MockStream();
      mockStream3 = MockStream();

      when(() => mockStream1.where(any())).thenAnswer((_) => mockStream1);
      when(() => mockStream2.where(any())).thenAnswer((_) => mockStream2);
      when(() => mockStream3.where(any())).thenAnswer((_) => mockStream3);

      when(() => mockStream1.listen(any())).thenReturn(mockSubscription1);
      when(() => mockStream2.listen(any())).thenReturn(mockSubscription2);
      when(() => mockStream3.listen(any())).thenReturn(mockSubscription3);

      logSink.listenTo(mockStream1);
      logSink.listenTo(mockStream2);
      logSink.listenTo(mockStream3);
    });

    test('should close all subscriptions', () async {
      // act
      await logSink.dispose();

      // assert
      verify(() => mockSubscription1.cancel());
      verify(() => mockSubscription2.cancel());
      verify(() => mockSubscription3.cancel());
    });
  });
}

class _LogSink with LogSinkMixin {
  _LogSink(this.writer, this.filter);

  final _MockLogWriter writer;
  @override
  final _MockLogFilter filter;

  @override
  Future<void> write(LogRecord logRecord) => writer.write(logRecord);
}

abstract class _LogWriter {
  Future<void> write(LogRecord logRecord);
}

class _MockLogWriter extends Mock implements _LogWriter {
  _MockLogWriter() {
    when(() => write(any())).thenAnswer((i) => Future.value());
  }
}

class _MockLogFilter extends Mock implements LogFilter {}
