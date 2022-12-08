import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:fox_logging/fox_logging.dart';
import 'package:mocktail/mocktail.dart';

class MockConverter<TFrom, TTo> extends Mock implements Converter<TFrom, TTo> {}

class MockFile extends Mock implements File {}

class MockEncoding extends Mock implements Encoding {}

class MockLogger extends Mock implements Logger {}

class MockLogSink extends Mock implements LogSink {
  MockLogSink() {
    when(() => write(any())).thenAnswer((i) => Future.value());
  }
}

class MockLogRecordFormatter extends Mock implements LogRecordFormatter {}

class MockIOSink extends Mock implements IOSink {
  MockIOSink() {
    when(() => flush()).thenAnswer((i) => Future.value());
    when(() => addStream(any())).thenAnswer((i) => Future.value());
    when(() => close()).thenAnswer((i) => Future.value());
    when(() => done).thenAnswer((i) => Future.value());
  }
}

class MockStream<T> extends Mock implements Stream<T> {}

class MockStreamSubscription<T> extends Mock implements StreamSubscription<T> {
  MockStreamSubscription() {
    when(() => cancel()).thenAnswer((i) => Future.value());
  }
}
