import 'dart:convert';

import 'package:mocktail/mocktail.dart';

class MockConverter<TFrom, TTo> extends Mock implements Converter<TFrom, TTo> {}
