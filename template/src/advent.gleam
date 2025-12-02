import gleam/bool
import gleam/int
import gleam/io
import gleam/list
import gleam/string

pub fn main() -> Nil {
  io.println("Hello from advent!")
}

pub fn parse(s: String) -> Int {
  let assert Ok(n) = int.parse(s)
  n
}

pub fn solve(input: String) -> Int {
  input
  |> string.split("\n")
  |> list.filter(fn(x) { bool.negate(string.is_empty(x)) })
  |> list.map(parse)
  |> list.fold(0, fn(a, b) { a + b })
}

pub fn solve1(input: String) -> Int {
  solve(input)
}

pub fn solve2(input: String) -> Int {
  solve(input)
}
