import advent.{FreshRange, ItemNumber, parse, parse_lines, solve1, solve2}
import gleeunit
import gleeunit/should
import input

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn parse_lines_test() {
  "1-2
  5"
  |> parse_lines
  |> should.equal([FreshRange(#(1, 2)), ItemNumber(5)])
}

pub fn parse_test() {
  "1-2
  5"
  |> parse
  |> should.equal(#([#(1, 2)], [5]))
}

pub fn example_1_test() {
  input.example |> solve1 |> should.equal(3)
}

pub fn problem_1_test() {
  input.problem |> solve1 |> should.equal(848)
}

pub fn example_2_test() {
  input.example |> solve2 |> should.equal(14)
}

pub fn problem_2_test() {
  input.problem |> solve2 |> should.equal(334_714_395_325_710)
}
