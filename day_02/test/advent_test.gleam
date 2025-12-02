import advent.{is_invalid, parse, solve1, solve2}
import gleeunit
import gleeunit/should
import input

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn parse_test() {
  "4399342-4505058" |> parse |> should.equal(#(4_399_342, 4_505_058))
}

pub fn example_1_test() {
  input.example |> solve1 |> should.equal(1_227_775_554)
}

pub fn problem_1_test() {
  input.problem |> solve1 |> should.equal(8_576_933_996)
}

// pub fn example_2_test() {
//   input.example |> solve2 |> should.equal(6)
// }

// pub fn problem_2_test() {
//   input.problem |> solve2 |> should.equal(0)
// }

pub fn is_invalid_test() {
  11 |> is_invalid |> should.be_true()
  123_123 |> is_invalid |> should.be_true()
  1_188_511_885 |> is_invalid |> should.be_true()
  123 |> is_invalid |> should.be_false()
}
