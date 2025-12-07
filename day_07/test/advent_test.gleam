import advent.{solve}
import gleeunit
import gleeunit/should
import input

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn example_1_test() {
  input.example |> solve |> fn(x) { x.0 } |> should.equal(21)
}

pub fn problem_1_test() {
  input.problem |> solve |> fn(x) { x.0 } |> should.equal(1615)
}

pub fn example_2_test() {
  input.example |> solve |> fn(x) { x.1 } |> should.equal(40)
}

pub fn problem_2_test() {
  input.problem |> solve |> fn(x) { x.1 } |> should.equal(43_560_947_406_326)
}
