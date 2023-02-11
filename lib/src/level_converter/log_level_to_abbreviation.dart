import 'package:fox_logging/src/level_converter/log_level_converter.dart';
import 'package:logging/logging.dart';

/// Converts a [Level] to its abbreviation.
class LogLevelToAbbreviationConverter extends LogLevelConverter<String> {
  /// Constructs a new [LogLevelToAbbreviationConverter].
  ///
  /// The default values are:
  /// - finest: `[V]` (verbose)
  /// - finer: `[D]` (debug)
  /// - fine: `[F]` (fine)
  /// - config: `[C]`
  /// - info: `[I]`
  /// - warning: `[W]`
  /// - severe: `[E]`
  /// - shout: `[WTF]`
  ///
  /// If the given input does not match any of the standard levels, an empty
  /// string is returned.
  LogLevelToAbbreviationConverter({
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
          finest: finest ?? '[V]',
          finer: finer ?? '[D]',
          fine: fine ?? '[F]',
          config: config ?? '[C]',
          info: info ?? '[I]',
          warning: warning ?? '[W]',
          severe: severe ?? '[E]',
          shout: shout ?? '[WTF]',
        );
}
