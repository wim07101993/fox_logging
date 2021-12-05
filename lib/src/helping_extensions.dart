extension ListExtension<T> on Iterable<T> {
  Iterable<TOut> mapMany<TOut>(Iterable<TOut> Function(T) selector) sync* {
    for (final outer in this) {
      for (final inner in selector(outer)) {
        yield inner;
      }
    }
  }
}
