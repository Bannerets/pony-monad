

trait val Either[L: Any val, R: Any val] is (Bifunctor[L, R] & Monad[R] & Foldable[R])
  fun map[TT: Any val](fn: { (R): TT } box): Either[L, TT]^
  fun chain[TT: Any val](fn: { (R): Either[L, TT] }): Either[L, TT]
  fun fold[B](fn: { (B, R): B } box, acc: B): B
  fun bimap[LL: Any val, RR: Any val](fn1: { (L): LL } box, fn2: { (R): RR } box): Bifunctor[LL, RR]^
  fun mapL[LL: Any val](fn: { (L): LL } box): Either[LL, R]^
  fun either[C](fn1: { (L): C }, fn2: { (R): C }): C
  fun isLeft(): Bool
  fun isRight(): Bool

class val Left[L: Any val, R: Any val] is Either[L, R]
  let _v: L

  new val create(v: L) => _v = v

  fun map[TT: Any val](fn: { (R): TT } box): Either[L, TT]^ =>
    Left[L, TT](_v)

  fun chain[TT: Any val](fn: { (R): Either[L, TT] }): Either[L, TT] =>
    Left[L, TT](_v)

  fun fold[B](fn: { (B, R): B } box, acc: B): B =>
    consume acc

  fun bimap[LL: Any val, RR: Any val](fn1: { (L): LL } box, fn2: { (R): RR } box): Bifunctor[LL, RR]^ =>
    Left[LL, RR](fn1(_v))

  fun mapL[LL: Any val](fn: { (L): LL } box): Either[LL, R]^ =>
    Left[LL, R](fn(_v))

  fun either[C](fn1: { (L): C }, fn2: { (R): C }): C =>
    fn1(_v)

  fun isLeft(): Bool => true
  fun isRight(): Bool => false

class val Right[L: Any val, R: Any val] is Either[L, R]
  let _v: R

  new val create(v: R) => _v = v

  fun map[TT: Any val](fn: { (R): TT } box): Either[L, TT]^ =>
    Right[L, TT](fn(_v))

  fun chain[TT: Any val](fn: { (R): Either[L, TT] }): Either[L, TT] =>
    fn(_v)

  fun fold[B](fn: { (B, R): B } box, acc: B): B =>
    fn(consume acc, _v)

  fun bimap[LL: Any val, RR: Any val](fn1: { (L): LL } box, fn2: { (R): RR } box): Bifunctor[LL, RR]^ =>
    Right[LL, RR](fn2(_v))

  fun mapL[LL: Any val](fn: { (L): LL } box): Either[LL, R]^ =>
    Right[LL, R](_v)

  fun either[C](fn1: { (L): C }, fn2: { (R): C }): C =>
    fn2(_v)

  fun isLeft(): Bool => false
  fun isRight(): Bool => true
