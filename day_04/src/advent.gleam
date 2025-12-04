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

pub fn which_rolls_can_be_pulled(grid: Grid) -> List(#(Int, Int)) {
  grid
  |> dict.keys
  |> list.filter(fn(pos) {
    let assert Ok(value) = dict.get(grid, pos)
    value == "@"
  })
  |> list.filter(fn(pos) {
    let num_neighbors =
      neighbors(grid, pos) |> list.filter(fn(x) { x == "@" }) |> list.length
    num_neighbors < 4
  })
}

pub fn solve1(input: String) -> Int {
  let grid = input |> parse_grid

  let valid_pulls = which_rolls_can_be_pulled(grid)

  valid_pulls |> list.length
}

pub fn count_rolls(grid: Grid) -> Int {
  grid |> dict.values |> list.filter(fn(x) { x == "@" }) |> list.length
}

pub fn recurse(grid: Grid) -> Grid {
  let valid_pulls = which_rolls_can_be_pulled(grid)
  case list.is_empty(valid_pulls) {
    True -> grid
    False -> {
      let grid_updates =
        valid_pulls |> list.map(fn(pos) { #(pos, ".") }) |> dict.from_list
      let updated_grid = dict.merge(grid, grid_updates)
      recurse(updated_grid)
    }
  }
}

pub fn solve2(input: String) -> Int {
  let grid = input |> parse_grid

  let original_count = count_rolls(grid)

  let final_grid = recurse(grid)
  let final_count = count_rolls(final_grid)
  let delta = original_count - final_count

  delta
}
