import advent.{is_invalid1, is_invalid2, parse, solve1, solve2, split_evenly}
import gleam/option
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

pub fn example_2_test() {
  input.example |> solve2 |> should.equal(4_174_379_265)
}

pub fn problem_2_test() {
  input.problem |> solve2 |> should.equal(25_663_320_831)
}

pub fn is_invalid1_test() {
  11 |> is_invalid1 |> should.be_true()
  123_123 |> is_invalid1 |> should.be_true()
  1_188_511_885 |> is_invalid1 |> should.be_true()
  123 |> is_invalid1 |> should.be_false()
}

pub fn is_invalid2_test() {
  999 |> is_invalid2 |> should.be_true()
  1010 |> is_invalid2 |> should.be_true()
  2_121_212_121 |> is_invalid2 |> should.be_true()
  824_824_824 |> is_invalid2 |> should.be_true()
  123 |> is_invalid2 |> should.be_false()
}

pub fn split_evenly_test() {
  "1234" |> split_evenly(2) |> should.equal(option.Some(["12", "34"]))
}
