import gleam/bool
import gleam/int
import gleam/io
import gleam/list
import gleam/order
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

// pub fn solve(input: String) -> Int {
//   input
//   |> string.split("\n")
//   |> list.filter(fn(x) { bool.negate(string.is_empty(x)) })
//   |> list.map(parse)
//   |> list.fold(0, fn(a, b) { a + b })
// }
pub fn score(input: #(Int, Int)) -> Int {
  input.0 * 10 + input.1
}

pub fn max_jolt(input: List(Int)) -> Int {
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

pub fn solve1(input: String) -> Int {
  let parsed =
    input
    |> string.split("\n")
    |> list.filter(fn(x) { bool.negate(string.is_empty(x)) })
    |> list.map(parse)
  let assert Ok(sum) = parsed |> list.map(max_jolt) |> list.reduce(int.add)
  sum
}

pub fn solve2(input: String) -> Int {
  todo
  // solve(input)
}
