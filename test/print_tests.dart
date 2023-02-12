import 'dart:async';

import 'package:test/test.dart';

void testWithPrint(
  String description,
  dynamic Function() body,
  dynamic Function(List<String> prints) onFinished,
) {
  final prints = <String>[];

  test(
    description,
    () {
      final zone = Zone.current.fork(
        specification: ZoneSpecification(
          print: (z, d, n, msg) => prints.add(msg),
        ),
      );
      return zone.run(() async {
        final result = body();
        if (result is Future) await result;
        return onFinished(prints);
      });
    },
  );
}
