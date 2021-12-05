import 'log_level_converter.dart';

class LogLevelToPrefixConverter extends LogLevelConverter<String> {
  LogLevelToPrefixConverter({
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
