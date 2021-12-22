import 'dart:async';

import 'package:logging/src/log_record.dart';
import 'package:logging_extensions/logging_extensions.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../faker_extensions.dart';
import '../../mocks.dart';

void main() {
  late _MockLogWriter mockWriter;

  late LogSink logSink;

  setUpAll(() {
    registerFallbackValue(faker.logRecord());
  });

  setUp(() {
    mockWriter = _MockLogWriter();

    logSink = _LogSink(mockWriter);
  });

  group('listenTo', () {
    late StreamController<LogRecord> streamController;

    setUp(() {
      streamController = StreamController();
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

class _LogSink extends LogSink {
  _LogSink(this.writer);

  final _MockLogWriter writer;

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
