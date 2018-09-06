use "ponytest"
use "../monad"
// use "debug"

actor Main is TestList
  new create(env: Env) => PonyTest(env, this)
  new make() => None

  fun tag tests(test: PonyTest) =>
    test(_Identity)
    test(_Maybe)
    test(_Either)
    test(_FromReadme)

class iso _Identity is UnitTest
  fun name(): String => "Identity"

  fun apply(h: TestHelper) =>
    let v = Identity[U32](2)
      .map[String]({ (n) => "n: " + n.string() })
      .chain[String]({ (str) => Identity[String](str + "!") })
      .identity()

    h.assert_eq[String](v, "n: 2!")

class iso _Maybe is UnitTest
  fun name(): String => "Maybe"

  fun apply(h: TestHelper) =>

    let vv = Just[String]("Hello")
      .chain[String]({ (str) => Nothing[String] })
      .map[String]({ (str) => str + ", world!" })
      .maybe[String]("Nothing!", { (x) => x })

    h.assert_eq[String](vv, "Nothing!")

    h.assert_true(Just[None](None).isJust())
    h.assert_false(Just[None](None).isNothing())
    h.assert_true(Nothing[None].isNothing())
    h.assert_false(Nothing[I32].isJust())

    maybeHelpers(h)

  fun maybeHelpers(h: TestHelper) =>
    let x: (U32 | None) = 2
    let y: (U32 | None) = None
    let xx: Maybe[U32] = MaybeHelpers.fromNullable[U32](x)
    let yy: Maybe[U32] = MaybeHelpers.fromNullable[U32](y)

    h.assert_eq[U32](
      xx.maybe[U32](99, { (x) => x }),
      yy.maybe[U32](2, { (y) => 33 })
    )

    h.assert_eq[String](
      MaybeHelpers.try1[I32, String]({ (n)? => error }, 5)
        .maybe[String]("err", { (x) => x }),
      "err")
    h.assert_eq[String](
      MaybeHelpers.try1[I32, String]({ (n) => n.string() }, 5)
        .maybe[String]("err", { (x) => x }),
      "5"
    )

class iso _Either is UnitTest
  fun name(): String => "Either"

  fun apply(h: TestHelper) =>

    let vvv = Right[String, U32](5)
      .map[U32]({ (n) => n + 8 })
      .chain[U32]({ (n) => Left[String, U32](
        "Oops! Error. n: " + n.string()) })
      .mapL[String]({ (str) => str + "!" })
      .either[String]({ (x) => "Left: " + x }, { (y) => "Right: " + y.string() })

    h.assert_eq[String](vvv, "Left: Oops! Error. n: 13!")

class iso _FromReadme is UnitTest
  fun name(): String => "From Readme"

  fun apply(h: TestHelper) =>
    // Identity[T]
    let v = Identity[U32](2)
      .map[String]({ (n) => "n: " + n.string() })
      .chain[String]({ (str) => Identity[String](str + "!") })
      .identity()

    // Debug(v) // => "n: 2!"

    // Maybe[T]
    let vv = Just[String]("Hello")
      .chain[String]({ (str) => Nothing[String] })
      .map[String]({ (str) => str + ", world!" })
      .maybe[String]("Nothing!", { (x) => x })

    // Debug(vv) // => "Nothing!"

    // Either[L, R]
    let vvv = Right[String, U32](5)
      .map[U32]({ (n) => n + 8 })
      .chain[U32]({ (n) => Left[String, U32](
        "Oops! Error. n: " + n.string()) })
      .mapL[String]({ (str) => str + "!" })
      .either[String]({ (x) => "Left: " + x }, { (y) => "Right: " + y.string() })

    // Debug(vvv) // => "Left: Oops! Error. n: 13!"
