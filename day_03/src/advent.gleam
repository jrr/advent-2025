import gleam/bool
import gleam/int
import gleam/io
import gleam/list
import gleam/string

pub fn main() -> Nil {
  io.println("Hello from advent!")
}

pub fn parse(s: String) -> List(Int) {
  s
  |> string.to_graphemes
  |> list.map(fn(s) {
    let assert Ok(n) = int.parse(s)
    n
  })
}

pub fn rebuild_integer(input: List(Int)) -> Int {
  input |> list.fold(0, fn(accum, n) { accum * 10 + n })
}

pub fn score(input: #(Int, Int)) -> Int {
  [input.0, input.1] |> rebuild_integer
}

pub fn score12(
  input: #(Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int),
) -> Int {
  [
    input.0,
    input.1,
    input.2,
    input.3,
    input.4,
    input.5,
    input.6,
    input.7,
    input.8,
    input.9,
    input.10,
    input.11,
  ]
  |> rebuild_integer
}

pub fn max_jolt_2(input: List(Int)) -> Int {
  let assert [a, b, ..tail] = input

  let result =
    tail
    |> list.fold(#(a, b), fn(accum, n) {
      let #(a, b) = accum
      let candidates = [#(a, b), #(a, n), #(b, n)]
      let assert Ok(top) =
        candidates |> list.max(fn(a, b) { int.compare(score(a), score(b)) })
      top
    })

  score(result)
}

pub fn max_jolt_12(input: List(Int)) -> Int {
  let assert [a, b, c, d, e, f, g, h, i, j, k, l, ..tail] = input

  let result =
    tail
    |> list.fold(#(a, b, c, d, e, f, g, h, i, j, k, l), fn(accum, n) {
      let #(a, b, c, d, e, f, g, h, i, j, k, l) = accum
      let candidates = [
        #(a, b, c, d, e, f, g, h, i, j, k, l),
        #(b, c, d, e, f, g, h, i, j, k, l, n),
        #(a, c, d, e, f, g, h, i, j, k, l, n),
        #(a, b, d, e, f, g, h, i, j, k, l, n),
        #(a, b, c, e, f, g, h, i, j, k, l, n),
        #(a, b, c, d, f, g, h, i, j, k, l, n),
        #(a, b, c, d, e, g, h, i, j, k, l, n),
        #(a, b, c, d, e, f, h, i, j, k, l, n),
        #(a, b, c, d, e, f, g, i, j, k, l, n),
        #(a, b, c, d, e, f, g, h, j, k, l, n),
        #(a, b, c, d, e, f, g, h, i, k, l, n),
        #(a, b, c, d, e, f, g, h, i, j, l, n),
        #(a, b, c, d, e, f, g, h, i, j, k, n),
      ]
      let assert Ok(top) =
        candidates |> list.max(fn(a, b) { int.compare(score12(a), score12(b)) })
      top
    })

  score12(result)
}

pub fn solve(input: String, max_jolt) {
  let parsed =
    input
    |> string.split("\n")
    |> list.filter(fn(x) { bool.negate(string.is_empty(x)) })
    |> list.map(parse)
  let assert Ok(sum) = parsed |> list.map(max_jolt) |> list.reduce(int.add)
  sum
}

pub fn solve1(input: String) -> Int {
  solve(input, max_jolt_2)
}

pub fn solve2(input: String) -> Int {
  solve(input, max_jolt_12)
}
