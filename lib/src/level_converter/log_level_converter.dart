import 'dart:convert';

import 'package:logging/logging.dart';

class LogLevelConverter<TOut> extends Converter<Level, TOut> {
  const LogLevelConverter({
    required this.defaultValue,
    this.finest,
    this.finer,
    this.fine,
    this.config,
    this.info,
    this.warning,
    this.severe,
    this.shout,
    this.all,
    this.off,
  });

  final TOut? finest;
  final TOut? finer;
  final TOut? fine;
  final TOut? config;
  final TOut? info;
  final TOut? warning;
  final TOut? severe;
  final TOut? shout;
  final TOut? all;
  final TOut? off;
  final TOut defaultValue;

  @override
  TOut convert(Level input) {
    TOut? value;
    if (input == Level.FINEST) {
      value = finest;
    } else if (input == Level.FINER) {
      value = finer;
    } else if (input == Level.FINE) {
      value = fine;
    } else if (input == Level.INFO) {
      value = info;
    } else if (input == Level.CONFIG) {
      value = config;
    } else if (input == Level.WARNING) {
      value = warning;
    } else if (input == Level.SEVERE) {
      value = severe;
    } else if (input == Level.SHOUT) {
      value = shout;
    } else if (input == Level.ALL) {
      value = all;
    } else if (input == Level.OFF) {
      value = off;
    }
    return value ?? defaultValue;
  }
}
