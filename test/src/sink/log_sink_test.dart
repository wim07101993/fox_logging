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
    registerFallbackValue(StackTrace.empty);
  });

  setUp(() {
    mockWriter = _MockLogWriter();
    mockFilter = _MockLogFilter();

    when(() => mockFilter.shouldLog(any())).thenReturn(true);

    logSink = _LogSink(mockWriter, mockFilter);
  });

  group('log', () {
    test('should write the log-record when the filter allows it', () async {
      // arrange
      final record = faker.logRecord();

      // act
      await logSink.log(record);

      // assert
      verify(() => mockWriter.write(record));
    });

    test('should not write the log-record when the filter blocks it', () async {
      // arrange
      when(() => mockFilter.shouldLog(any())).thenReturn(false);

      // act
      await logSink.log(faker.logRecord());

      // assert
      verifyNoMoreInteractions(mockWriter);
    });

    test('should report errors thrown by write instead of throwing', () async {
      // arrange
      final error = Exception(faker.lorem.sentence());
      when(() => mockWriter.write(any())).thenThrow(error);

      // act
      await logSink.log(faker.logRecord());

      // assert
      verify(() => mockWriter.onError(error, any()));
    });

    test('should report failing futures of write instead of throwing',
        () async {
      // arrange
      final error = Exception(faker.lorem.sentence());
      when(() => mockWriter.write(any()))
          .thenAnswer((i) => Future.error(error));

      // act
      await logSink.log(faker.logRecord());

      // assert
      verify(() => mockWriter.onError(error, any()));
    });
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

    test('should report errors emitted by the log-stream', () async {
      // arrange
      logSink.listenTo(streamController.stream);
      final error = Exception(faker.lorem.sentence());

      // act
      streamController.addError(error);

      // assert
      await Future.delayed(const Duration(milliseconds: 1));
      verify(() => mockWriter.onError(error, any()));
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

      when(() => mockStream1.listen(any(), onError: any(named: 'onError')))
          .thenReturn(mockSubscription1);
      when(() => mockStream2.listen(any(), onError: any(named: 'onError')))
          .thenReturn(mockSubscription2);
      when(() => mockStream3.listen(any(), onError: any(named: 'onError')))
          .thenReturn(mockSubscription3);

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

    test('should not cancel the same subscription twice', () async {
      // act
      await logSink.dispose();
      await logSink.dispose();

      // assert
      verify(() => mockSubscription1.cancel()).called(1);
      verify(() => mockSubscription2.cancel()).called(1);
      verify(() => mockSubscription3.cancel()).called(1);
    });
  });

  group('LogSink', () {
    test('should not filter any logs by default', () {
      // arrange
      // ignore: deprecated_member_use_from_same_package
      final sink = _DeprecatedLogSink(mockWriter);

      // act && assert
      expect(sink.filter.shouldLog(faker.logRecord()), isTrue);
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

  @override
  void onError(Object error, StackTrace stackTrace) {
    writer.onError(error, stackTrace);
  }
}

// ignore: deprecated_member_use_from_same_package
class _DeprecatedLogSink extends LogSink {
  _DeprecatedLogSink(this.writer);

  final _MockLogWriter writer;

  @override
  Future<void> write(LogRecord logRecord) => writer.write(logRecord);
}

abstract class _LogWriter {
  Future<void> write(LogRecord logRecord);

  void onError(Object error, StackTrace stackTrace);
}

class _MockLogWriter extends Mock implements _LogWriter {
  _MockLogWriter() {
    when(() => write(any())).thenAnswer((i) => Future.value());
  }
}

class _MockLogFilter extends Mock implements LogFilter {}
