import 'dart:io';

import 'package:logging_extensions/logging_extensions.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../faker_extensions.dart';
import '../../mocks.dart';

void main() {
  late FileMode fakeFileMode;
  late MockFile mockFile;
  late MockLogRecordFormatter mockFormatter;
  late MockIOSink mockIOSink;
  late MockEncoding mockEncoding;

  late FileLogSink logSink;

  setUpAll(() {
    registerFallbackValue(const Stream<List<int>>.empty());
    registerFallbackValue(FileMode.writeOnlyAppend);
    registerFallbackValue(MockEncoding());
  });

  setUp(() {
    fakeFileMode = faker.fileMode();
    mockFile = MockFile();
    mockFormatter = MockLogRecordFormatter();
    mockIOSink = MockIOSink();
    mockEncoding = MockEncoding();

    when(
      () => mockFile.openWrite(
        mode: any(named: 'mode'),
        encoding: any(named: 'encoding'),
      ),
    ).thenReturn(mockIOSink);

    logSink = FileLogSink(
      file: mockFile,
      formatter: mockFormatter,
      fileMode: fakeFileMode,
      encoding: mockEncoding,
    );
  });

  group('constructor', () {
    test('should set fields', () {
      // assert
      verify(
        () => mockFile.openWrite(mode: fakeFileMode, encoding: mockEncoding),
      );
      expect(logSink.formatter, mockFormatter);
      expect(logSink.sink, mockIOSink);
    });

    test('should set default value for fileMode', () {
      mockFile = MockFile();
      when(
        () => mockFile.openWrite(
          mode: any(named: 'mode'),
          encoding: any(named: 'encoding'),
        ),
      ).thenReturn(mockIOSink);

      // act
      FileLogSink(
        file: mockFile,
        formatter: mockFormatter,
        encoding: mockEncoding,
      );

      // assert
      verify(
        () => mockFile.openWrite(
          mode: FileMode.writeOnlyAppend,
          encoding: mockEncoding,
        ),
      );
      verifyNoMoreInteractions(mockFile);
    });

    test('should set default value for encoding', () {
      mockFile = MockFile();
      when(
        () => mockFile.openWrite(
          mode: any(named: 'mode'),
          encoding: any(named: 'encoding'),
        ),
      ).thenReturn(mockIOSink);

      // act
      FileLogSink(
        file: mockFile,
        formatter: mockFormatter,
        fileMode: fakeFileMode,
      );

      // assert
      verify(() => mockFile.openWrite(mode: fakeFileMode));
      verifyNoMoreInteractions(mockFile);
    });
  });

  group('dispose', () {
    test('should close sink', () async {
      // act
      await logSink.dispose();

      // assert
      verifyInOrder([
        () => mockIOSink.flush(),
        () => mockIOSink.close(),
      ]);
      verifyNoMoreInteractions(mockIOSink);
    });

    test('should dispose subscriptions', () async {
      // arrange
      final MockStreamSubscription<LogRecord> mockSubscription1 =
          MockStreamSubscription();
      final MockStreamSubscription<LogRecord> mockSubscription2 =
          MockStreamSubscription();
      final MockStreamSubscription<LogRecord> mockSubscription3 =
          MockStreamSubscription();

      final Stream<LogRecord> mockStream1 = MockStream();
      final Stream<LogRecord> mockStream2 = MockStream();
      final Stream<LogRecord> mockStream3 = MockStream();

      when(() => mockStream1.listen(any())).thenReturn(mockSubscription1);
      when(() => mockStream2.listen(any())).thenReturn(mockSubscription2);
      when(() => mockStream3.listen(any())).thenReturn(mockSubscription3);

      logSink.listenTo(mockStream1);
      logSink.listenTo(mockStream2);
      logSink.listenTo(mockStream3);

      // act
      await logSink.dispose();

      // assert
      verify(() => mockSubscription1.cancel());
      verify(() => mockSubscription2.cancel());
      verify(() => mockSubscription3.cancel());
    });
  });
}
