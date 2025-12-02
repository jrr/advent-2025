import day_01.{Left, Motion, parse, solve}
import gleeunit
import gleeunit/should

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
  let input =
    "L68
L30
R48
L5
R60
L55
L1
L99
R14
L82"

  solve(input) |> should.equal(3)
}
