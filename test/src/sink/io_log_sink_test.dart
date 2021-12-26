import 'dart:async';
import 'dart:io';

import 'package:logging_extensions/logging_extensions.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../faker_extensions.dart';
import '../../mocks.dart';

void main() {
  late IOSink mockSink;
  late LogRecordFormatter mockFormatter;

  late IOLogSink ioLogSink;

  setUpAll(() {
    registerFallbackValue(const Stream<List<int>>.empty());
    registerFallbackValue(faker.logRecord());
  });

  setUp(() {
    mockSink = MockIOSink();
    mockFormatter = MockLogRecordFormatter();

    ioLogSink = IOLogSink(
      sink: mockSink,
      formatter: mockFormatter,
    );
  });

  test('should set fields', () {
    expect(ioLogSink.formatter, mockFormatter);
    expect(ioLogSink.sink, mockSink);
  });

  group('write', () {
    late LogRecord fakeLogRecord;
    late String fakeFormattedLogRecord;

    setUp(() {
      fakeLogRecord = faker.logRecord();
      fakeFormattedLogRecord = faker.lorem.sentence();

      when(() => mockFormatter.format(any()))
          .thenReturn(fakeFormattedLogRecord);
    });

    test('should write the formatted log-record to the sink', () async {
      // act
      await ioLogSink.write(fakeLogRecord);

      // assert
      verifyInOrder([
        () => mockSink.writeln(fakeFormattedLogRecord),
        () => mockSink.flush(),
      ]);
      verifyNoMoreInteractions(mockSink);
    });
  });

  group('dispose', () {
    late StreamSubscription<LogRecord> mockStreamSubscription;
    late Stream<LogRecord> mockStream;

    setUp(() {
      mockStream = MockStream();
      mockStreamSubscription = MockStreamSubscription();

      when(() => mockStream.listen(any())).thenReturn(mockStreamSubscription);

      ioLogSink.listenTo(mockStream);
    });

    test('should dispose subscriptions', () async {
      // act
      await ioLogSink.dispose();

      // assert
      verify(() => mockSink.flush());
      verify(() => mockStreamSubscription.cancel());
      verifyNoMoreInteractions(mockSink);
    });
  });
}
