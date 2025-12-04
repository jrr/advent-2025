import advent.{parse_grid, parse_line, solve1, solve2}
import gleam/dict
import gleeunit
import gleeunit/should
import input

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn parse_line_test() {
  "..@@"
  |> parse_line
  |> should.equal([#(0, "."), #(1, "."), #(2, "@"), #(3, "@")])
}

pub fn parse_grid_test() {
  "..@
.@.
@@."
  |> parse_grid
  |> should.equal(
    dict.from_list([
      #(#(0, 0), "."),
      #(#(1, 0), "."),
      #(#(2, 0), "@"),
      #(#(0, 1), "."),
      #(#(1, 1), "@"),
      #(#(2, 1), "."),
      #(#(0, 2), "@"),
      #(#(1, 2), "@"),
      #(#(2, 2), "."),
    ]),
  )
}

pub fn small_solve_test() {
"...
.@.
..."
  |> solve1
  |> should.equal(1)
}
pub fn small_solve_2_test() {
"..@
.@.
@@."
  |> solve1
  |> should.equal(4)
}
pub fn example_1_test() {
  input.example |> solve1 |> should.equal(13)
}

pub fn problem_1_test() {
  input.problem |> solve1 |> should.equal(1527)
}

// pub fn example_2_test() {
//   input.example |> solve2 |> should.equal(6)
// }

// pub fn problem_2_test() {
//   input.problem |> solve2 |> should.equal(0)
// }
