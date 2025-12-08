import advent.{parse, Point3}
import gleeunit
import gleeunit/should

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn parse_test() {
  "1,2,3
  4,5,6" |> parse |> should.equal([Point3(1,2,3), Point3(4,5,6)])
}

// pub fn example_1_test() {
//   input.example |> solve1 |> should.equal(6)
// }

// pub fn problem_1_test() {
//   input.problem |> solve1 |> should.equal(0)
// }

// pub fn example_2_test() {
//   input.example |> solve2 |> should.equal(6)
// }

// pub fn problem_2_test() {
//   input.problem |> solve2 |> should.equal(0)
// }
