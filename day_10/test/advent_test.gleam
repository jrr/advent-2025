import input
import advent.{Machine, parse_line, solve_machine,bits_from_lights,bits_from_digits,solve1}
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

pub fn ex1_first_line_test() {
  "[.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}"
  |> parse_line
  |> solve_machine
  |> should.equal(2)
}

pub fn bits_from_lights_test(){
  [False,True,True,False] |> bits_from_lights |> should.equal(6)
}

pub fn bits_from_digits_test(){
  [0,3,4] |> bits_from_digits |> should.equal(25)
}
pub fn example_1_test() {
  input.example |> solve1 |> should.equal(7)
}

pub fn problem_1_test() {
  input.problem |> solve1 |> should.equal(434)
}

// pub fn example_2_test() {
//   input.example |> solve2 |> should.equal(6)
// }

// pub fn problem_2_test() {
//   input.problem |> solve2 |> should.equal(0)
// }
