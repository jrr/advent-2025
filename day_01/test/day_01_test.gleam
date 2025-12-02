import day_01.{Left, Motion, parse, solve}
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
  "L23" |> parse |> should.equal(Motion(23, Left))
}

pub fn example_test() {
  input.example |> solve |> should.equal(3)
}

pub fn problem_1_test() {
  input.problem |> solve |> should.equal(1086)
}
