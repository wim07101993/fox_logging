import 'package:logging/logging.dart';
import 'package:fox_logging/src/level_converter/log_level_converter.dart';

/// Converts a [Level] to a unicode symbol.
class LogLevelToSymbolConverter extends LogLevelConverter<String> {
  /// Constructs a new [LogLevelToSymbolConverter].
  ///
  /// The default values are:
  /// - finest: an empty string
  /// - finer: `🐞`
  /// - fine: `F`
  /// - config: `⚙`
  /// - info: `ⓘ`
  /// - warning: `⚠`
  /// - severe: `⛔`
  /// - shout: `(　ﾟДﾟ)＜!!`
  ///
  /// If the given input does not match any of the standard levels, an empty
  /// string is returned.
  LogLevelToSymbolConverter({
    String? defaultValue,
    String? finest,
    String? finer,
    String? fine,
    String? config,
    String? info,
    String? warning,
    String? severe,
    String? shout,
  }) : super(
          defaultValue: defaultValue ?? '',
          finest: finest ?? '',
          finer: finer ?? '🐞',
          fine: fine ?? 'F',
          config: config ?? '⚙️',
          info: info ?? 'ⓘ',
          warning: warning ?? '⚠',
          severe: severe ?? '⛔',
          shout: shout ?? '(　ﾟДﾟ)＜!!',
        );
}
