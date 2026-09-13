import 'package:logging/logging.dart';

/// Short-hand log methods, one per [Level] of the logging package.
extension LoggingExtensionsLoggerExtensions on Logger {
  /// Logs [message] at [Level.FINEST], the same as [Logger.finest].
  void v(Object? message, [Object? error, StackTrace? stackTrace]) {
    finest(message, error, stackTrace);
  }

  /// Logs [message] at [Level.FINER], the same as [Logger.finer].
  void d(Object? message, [Object? error, StackTrace? stackTrace]) {
    finer(message, error, stackTrace);
  }

  /// Logs [message] at [Level.FINE], the same as [Logger.fine].
  void f(Object? message, [Object? error, StackTrace? stackTrace]) {
    fine(message, error, stackTrace);
  }

  /// Logs [message] at [Level.CONFIG], the same as [Logger.config].
  void c(Object? message, [Object? error, StackTrace? stackTrace]) {
    config(message, error, stackTrace);
  }

  /// Logs [message] at [Level.INFO], the same as [Logger.info].
  void i(Object? message, [Object? error, StackTrace? stackTrace]) {
    info(message, error, stackTrace);
  }

  /// Logs [message] at [Level.WARNING], the same as [Logger.warning].
  void w(Object? message, [Object? error, StackTrace? stackTrace]) {
    warning(message, error, stackTrace);
  }

  /// Logs [message] at [Level.SEVERE], the same as [Logger.severe].
  void e(Object? message, [Object? error, StackTrace? stackTrace]) {
    severe(message, error, stackTrace);
  }

  /// Logs [message] at [Level.SHOUT], the same as [Logger.shout].
  void wtf(Object? message, [Object? error, StackTrace? stackTrace]) {
    shout(message, error, stackTrace);
  }
}
