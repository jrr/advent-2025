import day_01.{expand_motion, parse, solve1, solve2}
import gleeunit
import gleeunit/should
import input

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn parse_test() {
  "L23" |> parse |> should.equal(-23)
  "R42" |> parse |> should.equal(42)
}

pub fn expand_motion_test() {
  3 |> expand_motion |> should.equal([1, 1, 1])
  -5 |> expand_motion |> should.equal([-1, -1, -1, -1, -1])
}

pub fn example_1_test() {
  input.example |> solve1 |> should.equal(3)
}

pub fn problem_1_test() {
  input.problem |> solve1 |> should.equal(1086)
}

pub fn example_2_test() {
  input.example |> solve2 |> should.equal(6)
}

pub fn problem_2_test() {
  input.problem |> solve2 |> should.equal(6268)
}
