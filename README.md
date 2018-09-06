# pony-monad

Monads in [Pony](https://ponylang.org/).

## Usage

```pony
use "monad"
use "debug"

actor Main
  new create(env: Env) =>
    // Identity[T]
    let v = Identity[U32](2)
      .map[String]({ (n) => "n: " + n.string() })
      .chain[String]({ (str) => Identity[String](str + "!") })
      .identity()

    Debug(v) // => "n: 2!"

    // Maybe[T]
    let vv = Just[String]("Hello")
      .chain[String]({ (str) => Nothing[String] })
      .map[String]({ (str) => str + ", world!" })
      .maybe[String]("Nothing!", { (x) => x })

    Debug(vv) // => "Nothing!"

    // Either[L, R]
    let vvv = Right[String, U32](5)
      .map[U32]({ (n) => n + 8 })
      .chain[U32]({ (n) => Left[String, U32](
        "Oops! Error. n: " + n.string()) })
      .mapL[String]({ (str) => str + "!" })
      .either[String]({ (x) => "Left: " + x }, { (y) => "Right: " + y.string() })

    Debug(vvv) // => "Left: Oops! Error. n: 13!"
```

## Installation

Using [pony-stable](https://github.com/ponylang/pony-stable):

```console
$ stable add github Bannerets/pony-monad
$ stable fetch
```

## API

### `Functor a`

#### `map : (a -> b) -> Functor b`

Also known as `fmap`.

### `Monad a`

`Monad` is a subclass of `Functor`.

#### `chain : (a -> Monad b) -> Monad b`

Also known as `bind`, `flatMap`, `>>=`.

### `Foldable a`

#### `fold : (b -> a -> b) -> b -> b`

Also known as `foldl`, `foldLeft`, `reduce`.

### `Bifunctor a b`

`Bifunctor` is a subclass of `Functor`.

#### `bimap : (a -> c) -> (b -> d) -> Bifunctor c d`

---
---

### `Identity a`

```pony
Identity[A](a)
```

Identity monad.
Implements `Monad`, `Foldable`.

#### `identity : () -> a`

Unpacks value.

### `Maybe a`

```pony
Just[A](a)
Nothing[A]
```

Implements `Monad`, `Foldable`.

See also on [`hackage`](https://hackage.haskell.org/package/base-4.11.1.0/docs/Data-Maybe.html).

#### `maybe : b -> (a -> b) -> b`

#### `isJust : () -> Bool`

#### `isNothing : () -> Bool`

### `Either a b`

```pony
Left[A, B](a)
Right[A, B](b)
```

Implements `Bifunctor`, `Monad`, `Foldable`.

See also on [`hackage`](https://hackage.haskell.org/package/base-4.11.1.0/docs/Data-Either.html).

#### `either : (a -> c) -> (b -> c) -> c`

#### `mapL : (a -> c) -> Either c b`

#### `isLeft : () -> Bool`

#### `isRight : () -> Bool`

---
---

### `primitive MaybeHelpers`

Function list:

- `fromNullable[T]`
- `try1[A, R]`
- `try2[A, B, R]`
- `try3[A, B, C, R]`
