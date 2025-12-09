import advent.{parse,solve}
import gleeunit
import gleeunit/should
import input

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn parse_test() {
  input.example
  |> parse
  |> should.equal([
    #(7, 1),
    #(11, 1),
    #(11, 7),
    #(9, 7),
    #(9, 5),
    #(2, 5),
    #(2, 3),
    #(7, 3),
  ])
}
pub fn example_1_test() {
  input.example |> solve |> should.equal(50)
}

pub fn problem_1_test() {
  input.problem |> solve |> should.equal(4763040296)
}

// pub fn example_2_test() {
//   input.example |> solve2 |> should.equal(6)
// }

// pub fn problem_2_test() {
//   input.problem |> solve2 |> should.equal(0)
// }
