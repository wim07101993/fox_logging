/// Some useful extensions on [Iterable].
extension LoggingExtensionsListExtensions<T> on Iterable<T> {
  /// Selects a collection property with [selector] and adds all nested
  /// collections after each other.
  Iterable<TOut> mapMany<TOut>(Iterable<TOut> Function(T) selector) sync* {
    for (final outer in this) {
      for (final inner in selector(outer)) {
        yield inner;
      }
    }
  }
}
