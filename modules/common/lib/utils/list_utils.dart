extension IterableExtension<T> on Iterable<T>{
  Iterable<T> intersperse(T middle) sync* {
    final it = iterator;
    if (!it.moveNext()) return;
    yield it.current;
    while (it.moveNext()) {
      yield middle;
      yield it.current;
    }
  }
}