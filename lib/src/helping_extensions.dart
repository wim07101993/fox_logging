/// Some useful extensions on [Iterable].
extension LoggingExtensionsListExtensions<T> on Iterable<T> {
  /// MapMany will be removed in the next major release in favor of the expand function.
  @Deprecated(
    'MapMany will be removed in the next major release in favor of the expand function.',
  )
  Iterable<TOut> mapMany<TOut>(Iterable<TOut> Function(T) selector) sync* {
    for (final outer in this) {
      for (final inner in selector(outer)) {
        yield inner;
      }
    }
  }
}
