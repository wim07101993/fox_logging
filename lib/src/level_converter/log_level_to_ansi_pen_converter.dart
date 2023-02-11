import 'package:ansicolor/ansicolor.dart';
import 'package:fox_logging/src/level_converter/log_level_converter.dart';
import 'package:logging/logging.dart';

/// Converts a [Level] to an [AnsiPen].
class LogLevelToAnsiPenConverter extends LogLevelConverter<AnsiPen> {
  /// Constructs a new [LogLevelToAnsiPenConverter].
  ///
  /// The default values are:
  /// - finest: dark gray
  /// - finer: gray
  /// - fine: light gray
  /// - config: green
  /// - info: blue
  /// - warning: yellow
  /// - severe: red (background)
  /// - shout: magenta (background)
  ///
  /// If the given input does not match any of the standard levels, no color
  /// formatting is applied.
  LogLevelToAnsiPenConverter({
    AnsiPen? finest,
    AnsiPen? finer,
    AnsiPen? fine,
    AnsiPen? config,
    AnsiPen? info,
    AnsiPen? warning,
    AnsiPen? severe,
    AnsiPen? shout,
  }) : super(
          defaultValue: AnsiPen(),
          finest: finest ?? AnsiPen()
            ..gray(level: 0.5),
          finer: finer ?? AnsiPen()
            ..gray(level: 0.75),
          fine: fine ?? AnsiPen()
            ..gray(),
          config: config ?? AnsiPen()
            ..green(),
          info: info ?? AnsiPen()
            ..blue(),
          warning: warning ?? AnsiPen()
            ..yellow(),
          severe: severe ?? AnsiPen()
            ..red(bg: true),
          shout: shout ?? AnsiPen()
            ..magenta(bg: true, bold: true),
        );
}
