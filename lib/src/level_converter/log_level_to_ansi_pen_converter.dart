import 'package:ansicolor/ansicolor.dart';
import 'package:logging_extensions/src/level_converter/log_level_converter.dart';

class LogLevelToAnsiPenConverter extends LogLevelConverter<AnsiPen> {
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
