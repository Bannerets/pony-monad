

trait val Functor[T: Any val]
  fun map[TT: Any val](fn: { (T): TT } box): Functor[TT]^

trait val Applicative[T: Any val] is Functor[T]
  // TODO
  // new val pure(v: T)

trait val Monad[T: Any val] is Applicative[T]
  // new val of(v: T)
  // fun flat_map[TT: Any val](fn: { (T): Monad[TT] }): Monad[TT]

trait val Foldable[T: Any val]
  fun fold[B](fn: { (B, T): B^ } box, acc: B): B

trait val Bifunctor[A: Any val, B: Any val] is Functor[B]
  fun bimap[AA: Any val, BB: Any val](
    fn1: { (A): AA } box,
    fn2: { (B): BB } box
  ): Bifunctor[AA, BB]^
