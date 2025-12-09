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

pub type Point =
  #(Int, Int)

pub fn parse(s: String) -> List(Point) {
  s
  |> string.split("\n")
  |> list.filter(fn(x) { bool.negate(string.is_empty(x)) })
  |> list.map(fn(line) {
    let parts = line |> string.trim() |> string.split(",")
    let assert [x, y] = parts |> list.map(parse_int)
    #(x, y)
  })
}

pub fn rectangle_area(p1: Point, p2: Point) -> Int {
  let area1 = int.absolute_value(p1.0 - p2.0) + 1
  let area2 = int.absolute_value(p1.1 - p2.1) + 1
  area1 * area2
}

pub fn solve(input: String) -> Int {
  let assert Ok(largest) =
    input
    |> parse
    |> list.combination_pairs
    |> list.max(fn(a, b) {
      int.compare(rectangle_area(a.0, a.1), rectangle_area(b.0, b.1))
    })

  rectangle_area(largest.0, largest.1)
  // largest
  //   input
  //   |> string.split("\n")
  //   |> list.filter(fn(x) { bool.negate(string.is_empty(x)) })
  //   |> list.map(parse)
  //   |> list.fold(0, fn(a, b) { a + b })
}
// pub fn solve1(input: String) -> Int {
//   solve(input)
// }

// pub fn solve2(input: String) -> Int {
//   solve(input)
// }
