

class val Identity[T: Any val] is (Monad[T] & Foldable[T])
  let _v: T

  new val create(v: T) => _v = v

  fun map[TT: Any val](fn: { (T): TT } box): Identity[TT]^ =>
    Identity[TT](fn(_v))

  fun chain[TT: Any val](fn: { (T): Identity[TT] }): Identity[TT] =>
    fn(_v)

  fun fold[B](fn: { (B, T): B } box, acc: B): B =>
    fn(consume acc, _v)

  fun identity(): T => _v
