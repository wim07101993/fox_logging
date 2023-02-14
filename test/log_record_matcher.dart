import 'package:fox_logging/fox_logging.dart';
import 'package:test/test.dart';

Matcher equalsLogRecord(LogRecord expected) => _EqualsLogRecord(expected);

class _EqualsLogRecord extends Matcher {
  const _EqualsLogRecord(this._expected);

  final LogRecord _expected;

  @override
  Description describe(Description description) =>
      description.add('equals LogRecord').addDescriptionOf(_expected);

  @override
  bool matches(Object? item, Map matchState) {
    return item is! LogRecord ||
        item.loggerName != _expected.loggerName ||
        item.time != _expected.time ||
        item.zone != _expected.zone ||
        item.error != _expected.error ||
        item.level != _expected.level ||
        item.message != _expected.message ||
        item.object != _expected.object ||
        item.sequenceNumber != _expected.sequenceNumber ||
        item.stackTrace != _expected.stackTrace;
  }

  @override
  Description describeMismatch(
    Object? item,
    Description mismatchDescription,
    Map matchState,
    bool verbose,
  ) {
    if (item is! LogRecord) {
      return mismatchDescription.add('is not a LogRecord');
    }
    return super.describeMismatch(
      item,
      mismatchDescription,
      matchState,
      verbose,
    );
  }
}
