import advent.{max_jolt, parse, solve1, solve2}
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

// pub fn example_2_test() {
//   input.example |> solve2 |> should.equal(6)
// }

// pub fn problem_2_test() {
//   input.problem |> solve2 |> should.equal(0)
// }

pub fn max_jolt_test() {
  "987654321111111" |> parse |> max_jolt |> should.equal(98)
  "811111111111119" |> parse |> max_jolt |> should.equal(89)
  "234234234234278" |> parse |> max_jolt |> should.equal(78)
  "818181911112111" |> parse |> max_jolt |> should.equal(92)
}
