import advent.{parse, solve1, solve2}
import gleeunit
import gleeunit/should
import input

pub fn main() -> Nil {
  gleeunit.main()
}

// pub fn parse_test() {
//   "23" |> parse |> should.equal(23)
// }

pub fn example_1_test() {
  input.example |> solve1 |> should.equal(21)
}

pub fn problem_1_test() {
  input.problem |> solve1 |> should.equal(0)
}

// pub fn example_2_test() {
//   input.example |> solve2 |> should.equal(6)
// }

// pub fn problem_2_test() {
//   input.problem |> solve2 |> should.equal(0)
// }
