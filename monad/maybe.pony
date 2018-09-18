

trait val Maybe[T: Any val] is (Monad[T] & Foldable[T])
  fun map[TT: Any val](fn: { (T): TT } box): Maybe[TT]^
  fun chain[TT: Any val](fn: { (T): Maybe[TT] }): Maybe[TT]
  fun fold[B](fn: { (B, T): B } box, acc: B): B
  fun maybe[B](b: B, fn: { (T): B } box): B
  fun isJust(): Bool
  fun isNothing(): Bool

class val Just[T: Any val] is Maybe[T]
  let _v: T

  new val create(v: T) => _v = v

  fun map[TT: Any val](fn: { (T): TT } box): Maybe[TT]^ =>
    Just[TT](fn(_v))

  fun chain[TT: Any val](fn: { (T): Maybe[TT] }): Maybe[TT] =>
    fn(_v)

  fun fold[B](fn: { (B, T): B } box, acc: B): B =>
    fn(consume acc, _v)

  fun maybe[B](b: B, fn: { (T): B } box): B =>
    fn(_v)

  fun isJust(): Bool => true
  fun isNothing(): Bool => false

class val Nothing[T: Any val] is Maybe[T]
  new val create() => None

  fun map[TT: Any val](fn: { (T): TT } box): Maybe[TT]^ =>
    Nothing[TT]

  fun chain[TT: Any val](fn: { (T): Maybe[TT] }): Maybe[TT] =>
    Nothing[TT]

  fun fold[B](fn: { (B, T): B } box, acc: B): B =>
    consume acc

  fun maybe[B](b: B, fn: { (T): B } box): B =>
    consume b

  fun isJust(): Bool => false
  fun isNothing(): Bool => true

primitive MaybeHelpers
  fun fromNullable[T: Any val](x: (T | None)): Maybe[T] =>
    match x
    | None => Nothing[T]
    | let v: T => Just[T](v)
    end

  fun try1[A, R: Any val](fn: { (A): R ? }, a: A): Maybe[R] =>
    try Just[R](fn(consume a)?) else Nothing[R] end

  fun try2[A, B, R: Any val](fn: { (A, B): R ? }, a: A, b: B): Maybe[R] =>
    try Just[R](fn(consume a, consume b)?) else Nothing[R] end

  fun try3[A, B, C, R: Any val](fn: { (A, B, C): R ? }, a: A, b: B, c: C): Maybe[R] =>
    try Just[R](fn(consume a, consume b, consume c)?) else Nothing[R] end
