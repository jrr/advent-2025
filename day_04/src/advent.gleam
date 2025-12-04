import gleam/dict
import gleam/io
import gleam/list
import gleam/option
import gleam/result
import gleam/string

pub fn main() -> Nil {
  io.println("Hello from advent!")
}

pub fn parse_line(s: String) -> List(#(Int, String)) {
  s
  |> string.to_graphemes
  |> list.index_map(fn(x, i) { #(i, x) })
}

type Grid =
  dict.Dict(#(Int, Int), String)

pub fn parse_grid(s: String) -> Grid {
  s
  |> string.split("\n")
  |> list.index_map(fn(line, y) {
    line
    |> string.to_graphemes
    |> list.index_map(fn(char, x) { #(#(x, y), char) })
  })
  |> list.flatten
  |> dict.from_list
}

pub fn neighbors(grid: Grid, pos: #(Int, Int)) -> List(String) {
  let #(x, y) = pos

  let coords = [
    #(x - 1, y),
    #(x + 1, y),
    #(x, y - 1),
    #(x, y + 1),
    #(x - 1, y - 1),
    #(x + 1, y - 1),
    #(x - 1, y + 1),
    #(x + 1, y + 1),
  ]
  let what =
    coords
    |> list.map(fn(coord) { dict.get(grid, coord) })
    |> list.filter(result.is_ok)
    |> list.map(fn(r) {
      let assert Ok(v) = r
      v
    })

  what
}

pub fn solve(input: String) -> Int {
  let grid = input |> parse_grid
  let neighbor_counts =
    grid
    |> dict.keys
    |> list.filter(fn(pos) {
      let assert Ok(value) = dict.get(grid, pos)
      value == "@"
    })
    |> list.map(fn(pos) {
      neighbors(grid, pos) |> list.filter(fn(x) { x == "@" }) |> list.length
    }) |> list.filter(fn(x) { x < 4 })
  // echo neighbor_counts as "neighbor counts"
  // input
  // |> string.split("\n")
  // |> list.filter(fn(x) { bool.negate(string.is_empty(x)) })
  // |> list.map(parse)
  // |> list.fold(0, fn(a, b) { a + b })
  neighbor_counts |> list.length
}

pub fn solve1(input: String) -> Int {
  solve(input)
}

pub fn solve2(input: String) -> Int {
  solve(input)
}
