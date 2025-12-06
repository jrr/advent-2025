import advent.{Add, Multiply, parse, solve1, solve2, sort}
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
    #(
      [
        Multiply,
        Add,
        Multiply,
        Add,
      ],
      [
        [123, 328, 51, 64],
        [45, 64, 387, 23],
        [6, 98, 215, 314],
      ],
    ),
  )
}

pub fn sort_test() {
  input.example
  |> parse
  |> sort
  |> should.equal([
    #(Multiply, [6, 45, 123]),
    #(Add, [98, 64, 328]),
    #(Multiply, [215, 387, 51]),
    #(Add, [314, 23, 64]),
  ])
}


pub fn example_1_test() {
  input.example |> solve1 |> should.equal(4_277_556)
}

pub fn problem_1_test() {
  input.problem |> solve1 |> should.equal(6_299_564_383_938)
}

pub fn example_2_test() {
  input.example |> solve2|> should.equal(3263827)
}

pub fn problem_2_test() {
  input.problem |> solve2 |> should.equal(11950004808442)
}
