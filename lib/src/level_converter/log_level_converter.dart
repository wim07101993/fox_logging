import 'dart:convert';

import 'package:logging/logging.dart';

/// A [Converter] which converts a [Level] to a generic output.
///
/// For given [Level], the output value can be found at the corresponding field.
class LogLevelConverter<TOut> extends Converter<Level, TOut> {
  /// Constructs a new [LogLevelConverter].
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

  /// Return value when the level is [Level.FINEST].
  final TOut? finest;

  /// Return value when the level is [Level.FINER].
  final TOut? finer;

  /// Return value when the level is [Level.FINE].
  final TOut? fine;

  /// Return value when the level is [Level.CONFIG].
  final TOut? config;

  /// Return value when the level is [Level.INFO].
  final TOut? info;

  /// Return value when the level is [Level.WARNING].
  final TOut? warning;

  /// Return value when the level is [Level.SEVERE].
  final TOut? severe;

  /// Return value when the level is [Level.SHOUT].
  final TOut? shout;

  /// Return value when the level is [Level.ALL].
  final TOut? all;

  /// Return value when the level is [Level.OFF].
  final TOut? off;

  /// Return value when the level is not one of the standard values.
  final TOut defaultValue;

  /// Returns the field ([finest], [finer], ...) which corresponds with the
  /// given [input].
  ///
  /// If [input] corresponds with none of the fields, [defaultValue] is
  /// returned.
  @override
  TOut convert(Level input) {
    return switch (input) {
          Level.FINEST => finest,
          Level.FINER => finer,
          Level.FINE => fine,
          Level.INFO => info,
          Level.CONFIG => config,
          Level.WARNING => warning,
          Level.SEVERE => severe,
          Level.SHOUT => shout,
          Level.ALL => all,
          Level.OFF => off,
          Level() => null,
        } ??
        defaultValue;
  }
}
