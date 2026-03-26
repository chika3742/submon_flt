/// 同じ値でも別のイベントとして区別するためのラッパークラス。
/// const を付けると無意味になる。
class Distinguish<T> {
  Distinguish(this.value);

  final T value;
}
