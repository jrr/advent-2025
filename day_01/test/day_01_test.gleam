import day_01.{solve}
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
