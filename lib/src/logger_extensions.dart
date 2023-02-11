import 'package:logging/logging.dart';

extension LoggingExtensionsLoggerExtensions on Logger {
  void v(Object? message, [Object? error, StackTrace? stackTrace]) {
    finest(message, error, stackTrace);
  }

  void d(Object? message, [Object? error, StackTrace? stackTrace]) {
    finer(message, error, stackTrace);
  }

  void f(Object? message, [Object? error, StackTrace? stackTrace]) {
    fine(message, error, stackTrace);
  }

  void c(Object? message, [Object? error, StackTrace? stackTrace]) {
    config(message, error, stackTrace);
  }

  void i(Object? message, [Object? error, StackTrace? stackTrace]) {
    info(message, error, stackTrace);
  }

  void w(Object? message, [Object? error, StackTrace? stackTrace]) {
    warning(message, error, stackTrace);
  }

  void e(Object? message, [Object? error, StackTrace? stackTrace]) {
    severe(message, error, stackTrace);
  }

  void wtf(Object? message, [Object? error, StackTrace? stackTrace]) {
    shout(message, error, stackTrace);
  }
}
