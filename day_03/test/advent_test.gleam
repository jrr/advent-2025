import advent.{max_jolt_12, max_jolt_2, parse, solve1, solve2}
import gleeunit
import gleeunit/should
import input

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn parse_test() {
  "23" |> parse |> should.equal([2, 3])
}

pub fn example_1_test() {
  input.example |> solve1 |> should.equal(357)
}

pub fn problem_1_test() {
  input.problem |> solve1 |> should.equal(17_229)
}

pub fn example_2_test() {
  input.example |> solve2 |> should.equal(3_121_910_778_619)
}

pub fn problem_2_test() {
  input.problem |> solve2 |> should.equal(170_520_923_035_051)
}

pub fn max_jolt_2_test() {
  "987654321111111" |> parse |> max_jolt_2 |> should.equal(98)
  "811111111111119" |> parse |> max_jolt_2 |> should.equal(89)
  "234234234234278" |> parse |> max_jolt_2 |> should.equal(78)
  "818181911112111" |> parse |> max_jolt_2 |> should.equal(92)
}

pub fn max_jolt_12_test() {
  "987654321111111" |> parse |> max_jolt_12 |> should.equal(987_654_321_111)
  "811111111111119" |> parse |> max_jolt_12 |> should.equal(811_111_111_119)
  "234234234234278" |> parse |> max_jolt_12 |> should.equal(434_234_234_278)
  "818181911112111" |> parse |> max_jolt_12 |> should.equal(888_911_112_111)
}
