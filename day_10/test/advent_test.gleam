import advent.{Machine, parse_line}
import gleeunit
import gleeunit/should

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn parse_test() {
  "[.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}"
  |> parse_line
  |> should.equal(
    Machine(
      [False, True, True, False],
      [[3], [1, 3], [2], [2, 3], [0, 2], [0, 1]],
      [3, 5, 4, 7],
    ),
  )
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
