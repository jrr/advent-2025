import advent.{Add, Multiply, parse, solve1, solve2}
import gleeunit
import gleeunit/should
import input

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn parse_test() {
  input.example
  |> parse
  |> should.equal(
    #([[123, 328, 51, 64], [45, 64, 387, 23], [6, 98, 215, 314]], [
      Multiply,
      Add,
      Multiply,
      Add,
    ]),
  )
}

pub fn example_1_test() {
  input.example |> solve1 |> should.equal(6)
}

pub fn problem_1_test() {
  input.problem |> solve1 |> should.equal(0)
}

pub fn example_2_test() {
  input.example |> solve2 |> should.equal(6)
}

pub fn problem_2_test() {
  input.problem |> solve2 |> should.equal(0)
}
