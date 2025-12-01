import day_01.{parse, solve1, solve2}
import gleeunit
import gleeunit/should
import input

pub fn main() -> Nil {
  gleeunit.main()
}

// gleeunit test functions end in `_test`
pub fn hello_world_test() {
  let name = "Joe"
  let greeting = "Hello, " <> name <> "!"

  assert greeting == "Hello, Joe!"
}

pub fn parse_test() {
  "L23" |> parse |> should.equal(-23)
  "R42" |> parse |> should.equal(42)
}

pub fn example_1_test() {
  input.example |> solve1 |> should.equal(3)
}

pub fn problem_1_test() {
  input.problem |> solve1 |> should.equal(1086)
}

pub fn example_2_test() {
  input.example |> solve2 |> should.equal(6)
}

pub fn problem_2_test() {
  input.problem |> solve2 |> should.equal(6268)
}
