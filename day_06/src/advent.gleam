import gleam/bool
import gleam/int
import gleam/io
import gleam/list
import gleam/string

pub fn main() -> Nil {
  io.println("Hello from advent!")
}

fn parse_int(s: String) -> Int {
  let assert Ok(x) = int.parse(s)
  x
}

pub type Operation {
  Add
  Multiply
}

fn parse_op(string: String) -> Operation {
  case string {
    "+" -> Add
    "*" -> Multiply
    _ -> panic
  }
}

pub fn is_not_empty(s: String) {
  bool.negate(string.is_empty(s))
}

pub fn parse(s: String) {
  let lines =
    s
    |> string.split("\n")
    |> list.filter(is_not_empty)
  let len = lines |> list.length
  let lines_of_cols =
    lines
    |> list.map(fn(line) {
      line |> string.split(" ") |> list.filter(is_not_empty)
    })
  let #(a, b) = lines_of_cols |> list.split(len - 1)
  let assert [ops] = b
  let nums = a |> list.map(fn(s) { s |> list.map(parse_int) })
  let operations = ops |> list.map(parse_op)

  #(nums, operations)
}

pub fn solve(input: String) -> Int {
  todo
  // input
  // |> string.split("\n")
  // |> list.filter(fn(x) { bool.negate(string.is_empty(x)) })
  // |> list.map(parse)
  // |> list.fold(0, fn(a, b) { a + b })
  // 0
}

pub fn solve1(input: String) -> Int {
  solve(input)
}

pub fn solve2(input: String) -> Int {
  solve(input)
}
