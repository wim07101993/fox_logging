import 'log_level_converter.dart';

class LogLevelToSymbolConverter extends LogLevelConverter<String> {
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
          info: info ?? '🛈',
          warning: warning ?? '⚠',
          severe: severe ?? '⛔',
          shout: shout ?? '(　ﾟДﾟ)＜!!',
        );
}
