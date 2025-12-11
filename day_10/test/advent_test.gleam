import gleam/list
import gleam/string
import advent.{
  ButtonWithNumPresses, Machine, add_digits, all_button_press_combinations,
  bits_from_digits, bits_from_lights, compare, digits_to_int, expand_combos,
  how_many_fit, ones_and_zeroes_from_digits, parse_line, solve1, solve2,
  solve_machine,
}
import gleam/order
import gleeunit
import gleeunit/should
import input

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

pub fn bits_from_lights_test() {
  [False, True, True, False] |> bits_from_lights |> should.equal(6)
}

pub fn bits_from_digits_test() {
  [0, 3, 4] |> bits_from_digits |> should.equal(25)
}

pub fn example_1_test() {
  input.example |> solve1 |> should.equal(7)
}

pub fn problem_1_test() {
  input.problem |> solve1 |> should.equal(434)
}

pub fn digits_to_int_test() {
  [1, 2, 3] |> digits_to_int |> should.equal(123)
  [0, 7, 2] |> digits_to_int |> should.equal(72)
}

pub fn compare_test() {
  assert compare([0, 7, 2], [2, 3, 4]) == order.Gt
  assert compare([2, 3, 4], [2, 7, 5]) == order.Lt
  assert compare([3, 2, 1], [3, 2, 1]) == order.Eq
}

pub fn add_digits_test() {
  add_digits([1, 2, 3], [2, 3, 4]) |> should.equal([3, 5, 7])
}

pub fn ones_and_zeroes_from_digits_test() {
  [1, 3, 5]
  |> ones_and_zeroes_from_digits(8)
  |> should.equal([0, 1, 0, 1, 0, 1, 0, 0])
}

pub fn exasmple2_first_line_test(){
  let assert Ok(first_line) = input.example |> string.split("\n") |> list.first 
  first_line |> solve2 |> should.equal(10)
}
pub fn example_2_test() {
  input.example |> solve2 |> should.equal(33)
}

// pub fn problem_2_test() {
//   input.problem |> solve2 |> should.equal(0)
// }

pub fn how_many_fit_test() {
  how_many_fit([1, 1, 1], [3, 3, 3]) |> should.equal(3)
  how_many_fit([1, 1, 4], [9, 9, 9]) |> should.equal(2)
}

pub fn all_button_press_combinations_test() {
  let input = [
    #([0, 0, 0, 1], 2),
    #([0, 1, 0, 1], 1),
    #([0, 0, 1, 0], 3),
  ]
  input
  |> all_button_press_combinations
  |> should.equal([
    [0, 0, 0, 1],
    [0, 0, 0, 1],
    [0, 1, 0, 1],
    [0, 0, 1, 0],
    [0, 0, 1, 0],
    [0, 0, 1, 0],
  ])
}

pub fn expand_combos_basic_test() {
  assert [ButtonWithNumPresses(button: [1, 0, 1, 0], num_presses: 3)]
    |> expand_combos
    == [
      [
        ButtonWithNumPresses(button: [1, 0, 1, 0], num_presses: 0),
        ButtonWithNumPresses(button: [1, 0, 1, 0], num_presses: 1),
        ButtonWithNumPresses(button: [1, 0, 1, 0], num_presses: 2),
        ButtonWithNumPresses(button: [1, 0, 1, 0], num_presses: 3),
      ],
    ]
}

pub fn expand_combos_advanced_test() {
  assert [
      ButtonWithNumPresses(button: [1, 0], num_presses: 2),
      ButtonWithNumPresses(button: [0, 1], num_presses: 3),
    ]
    |> expand_combos
    == [
      [
        ButtonWithNumPresses(0, [1, 0]),
        ButtonWithNumPresses(1, [1, 0]),
        ButtonWithNumPresses(2, [1, 0]),
      ],
      [
        ButtonWithNumPresses(0, [0, 1]),
        ButtonWithNumPresses(1, [0, 1]),
        ButtonWithNumPresses(2, [0, 1]),
        ButtonWithNumPresses(3, [0, 1]),
      ],
    ]
}
