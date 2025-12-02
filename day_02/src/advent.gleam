import gleam/bool
import gleam/int
import gleam/io
import gleam/list
import gleam/order
import gleam/string

pub fn main() -> Nil {
  io.println("Hello from advent!")
}

fn parse_int(s: String) -> Int {
  let assert Ok(x) = int.parse(s)
  x
}

pub fn parse(s: String) -> #(Int, Int) {
  let assert [x, y] = string.split(s, "-") |> list.map(parse_int)
  #(x, y)
}

pub fn solve(input: String) -> Int {
  input
  |> string.split(",")
  |> list.filter(fn(x) { bool.negate(string.is_empty(x)) })
  |> list.map(parse)
  |> list.flat_map(fn(range) { list.range(range.0, range.1) })
  |> list.filter(is_invalid)
  |> list.fold(0, fn(a, b) { a + b })
}

pub fn is_invalid(n: Int) -> Bool {
  let s = int.to_string(n)

  let len = string.length(s)
  case len {
    n if n % 2 != 0 -> False
    _ -> {
      let left = s |> string.drop_start(len / 2)
      let right = s |> string.drop_end(len / 2)
      case string.compare(left, right) {
        order.Eq -> True
        _ -> False
      }
    }
  }
}

pub fn solve1(input: String) -> Int {
  solve(input)
}

pub fn solve2(input: String) -> Int {
  solve(input)
}
