import gleam/bool
import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import gleam/order
import gleam/string
import gleam/yielder

pub fn main() -> Nil {
  io.println("Hello from advent!")
}

pub type Machine {

  Machine(lights: List(Bool), buttons: List(List(Int)), joltage: List(Int))
}

pub fn parse_line(line: String) -> Machine {
  let segments = line |> string.split(" ")
  let assert [lights_text, ..tail] = segments
  let button_texts = tail |> list.take(list.length(tail) - 1)
  let assert Ok(joltage_text) = tail |> list.last

  Machine(
    lights: parse_lights(lights_text),
    buttons: button_texts |> list.map(parse_numbers),
    joltage: parse_numbers(joltage_text),
  )
}

fn parse_int(s: String) -> Int {
  let assert Ok(x) = int.parse(s)
  x
}

fn parse_numbers(s: String) -> List(Int) {
  let len = string.length(s)

  s
  |> string.slice(1, len - 2)
  |> string.split(",")
  |> list.map(parse_int)
}

fn parse_lights(lights_text: String) -> List(Bool) {
  let len = string.length(lights_text)
  lights_text
  |> string.slice(1, len - 2)
  |> string.to_graphemes
  |> list.map(fn(c) {
    case c {
      "." -> False
      "#" -> True
      _ -> panic
    }
  })
}

pub fn parse(s: String) -> List(Machine) {
  s
  |> string.split("\n")
  |> list.filter(fn(x) { bool.negate(string.is_empty(x)) })
  |> list.map(parse_line)
}

pub fn solve1(input: String) -> Int {
  let parsed = input |> parse
  let assert Ok(sum) =
    parsed
    |> list.map(solve_machine)
    |> list.reduce(int.add)
  sum
}

pub fn solve_machine(machine: Machine) -> Int {
  let num_buttons = machine.buttons |> list.length
  let r = list.range(0, num_buttons)

  let goal = bits_from_lights(machine.lights)

  let all_combinations =
    r
    |> list.flat_map(fn(n) { machine.buttons |> list.combinations(n) })
  // echo list.length(all_combinations) as "total"
  let matches =
    all_combinations
    |> list.filter(fn(combo) {
      let sum =
        combo
        |> list.map(bits_from_digits)
        |> list.reduce(int.bitwise_exclusive_or)
      let candidate = case sum {
        Ok(n) -> n
        Error(_) -> 0
      }
      candidate == goal
    })
  let assert Ok(min_len) =
    matches |> list.map(list.length) |> list.max(fn(a, b) { int.compare(b, a) })
  min_len
}

pub fn bits_from_lights(lights: List(Bool)) -> Int {
  let assert Ok(goal) =
    lights
    |> list.index_map(fn(l, i) {
      case l {
        True -> int.bitwise_shift_left(1, i)
        False -> 0
      }
    })
    |> list.reduce(int.bitwise_exclusive_or)
  goal
}

pub fn bits_from_digits(digits: List(Int)) -> Int {
  let assert Ok(n) =
    digits
    |> list.map(fn(d) { int.bitwise_shift_left(1, d) })
    |> list.reduce(int.bitwise_exclusive_or)
  n
}

pub type ButtonOnesAndZeroes =
  List(Int)

pub fn ones_and_zeroes_from_digits(
  digits: List(Int),
  len: Int,
) -> ButtonOnesAndZeroes {
  let ones = digits |> list.map(fn(d) { #(d, 1) }) |> dict.from_list
  list.range(0, len - 1)
  |> list.index_map(fn(_, i) {
    let one = ones |> dict.get(i)
    case one {
      Ok(_) -> 1
      _ -> 0
    }
  })
}

pub fn all_button_press_combinations(how_many_of_each: List(#(List(Int), Int))) {
  let list_of_yielders = how_many_of_each |> list.map(yield_one_button)
  list_of_yielders |> list.flat_map(yielder.to_list)
}

fn yield_one_button(value: #(List(Int), Int)) {
  let #(b, howmany) = value
  yielder.repeat(b) |> yielder.take(up_to: howmany)
}

pub fn solve_machine_joltage(machine: Machine) -> Int {
  let num_lights = machine.lights |> list.length
  let goal = machine.joltage
  let button_ones_and_zeroes: List(ButtonOnesAndZeroes) =
    machine.buttons
    |> list.map(fn(b) { ones_and_zeroes_from_digits(b, num_lights) })

  // all buttons with the maximum number of times they could be pressed without overflowing their digits
  // e.g. "9x button #1, 5x button #2, ..."
  let how_many_max_of_each =
    button_ones_and_zeroes
    |> list.map(fn(b) {
      ButtonWithNumPresses(num_presses: how_many_fit(b, goal), button: b)
    })

  // all buttons with all numbers of times they could be pressed. 
  // e.g. [0x0, 0x1], [1x0, 1x1], ...
  let all_combinations: List(List(ButtonWithNumPresses)) =
    expand_combos(how_many_max_of_each)
  // how_many_of_each |> all_button_press_combinations

  let empty = list.repeat(0, num_lights)

  let solutions_found = recurse2(0, [], empty, goal, all_combinations)
  // echo "found " <> int.to_string(list.length(solutions_found)) <> " solutions"
  let shortest =
    solutions_found
    |> list.filter_map(fn(sol) {
      case sol {
        MetGoal(x) -> Ok(x)
        _ -> Error(Nil)
      }
    })
    // let num_clicks = shortest |> list.map(fn(sol){
    // })
    |> list.flatten
  // echo { shortest |> list.length } as "number of solutions"
  // echo shortest as "SHORTEST"
  // shortest
  // |> list.map(fn(sol) {
  //   let score: Int = score_solution(sol)

  //   echo score as "score"
  //   echo sol
  // })
  let assert Ok(winner) =
    shortest
    |> list.map(score_solution)
    |> list.max(fn(a, b) { int.compare(b, a) })
  winner
}

fn score_solution(sol: List(ButtonWithNumPresses)) -> Int {
  let assert Ok(x) =
    sol |> list.map(fn(s) { s.num_presses }) |> list.reduce(int.add)
  x
}

type ButtonDigits =
  List(Int)

fn add_buttons(left: ButtonDigits, right: ButtonDigits) -> ButtonDigits {
  list.zip(left, right) |> list.map(fn(x) { x.0 + x.1 })
}

fn multiply_button(b: ButtonDigits, n: Int) -> ButtonDigits {
  b |> list.map(fn(d) { d * n })
}

type RecurseResult {
  Overflowed
  MetGoal(List(List(ButtonWithNumPresses)))
  Empty
}

fn recurse2(
  num_presses_so_far: Int,
  the_presses_so_far: List(ButtonWithNumPresses),
  sum_so_far: ButtonDigits,
  goal: ButtonDigits,
  all_combinations: List(List(ButtonWithNumPresses)),
) -> List(RecurseResult) {
  let comparison = compare(sum_so_far, goal)
  case comparison {
    order.Gt -> [Overflowed]
    order.Eq -> [MetGoal([the_presses_so_far])]
    order.Lt -> {
      let what = case all_combinations {
        [first_button, ..remaining_buttons] -> {
          first_button
          |> list.map(fn(presses_of_one_button) {
            let multiplied =
              multiply_button(
                presses_of_one_button.button,
                presses_of_one_button.num_presses,
              )
            let new_sum = add_buttons(sum_so_far, multiplied)
            let updated_presses_list = [
              presses_of_one_button,
              ..the_presses_so_far
            ]
            let resolved_tails =
              recurse2(
                num_presses_so_far + 1,
                updated_presses_list,
                new_sum,
                goal,
                remaining_buttons,
              )

            let combined =
              resolved_tails
              |> list.filter(fn(x) {
                case x {
                  MetGoal(_) -> True
                  _ -> False
                }
              })
              |> list.map(fn(tail) {
                case tail {
                  MetGoal(solutions) -> {
                    let shortened_solutions =
                      solutions
                      |> list.map(fn(sol) {
                        sol |> list.filter(fn(s) { s.num_presses != 0 })
                      })

                    MetGoal(shortened_solutions)
                  }
                  _ -> panic as "shouldn't happen"
                }
              })
              |> list.reduce(fn(left, right) {
                case left, right {
                  MetGoal(l), MetGoal(r) -> MetGoal(list.append(l, r))
                  _, _ -> panic
                }
              })
            case combined {
              Ok(MetGoal(a)) -> MetGoal(a)
              _ -> {
                Empty
              }
            }
          })
        }
        [] -> [Empty]
      }
      what
    }
  }
}

fn expand_one_button(b: ButtonWithNumPresses) -> List(ButtonWithNumPresses) {
  list.range(0, b.num_presses)
  |> list.map(fn(n) { ButtonWithNumPresses(..b, num_presses: n) })
}

pub fn expand_combos(
  how_many_max_of_each: List(ButtonWithNumPresses),
) -> List(List(ButtonWithNumPresses)) {
  case how_many_max_of_each {
    [head, ..tail] -> {
      let expanded_head = expand_one_button(head)
      let resolved_tail = expand_combos(tail)
      list.append([expanded_head], resolved_tail)
    }
    [] -> [how_many_max_of_each]
  }
  |> list.filter(fn(x) { !list.is_empty(x) })
}

pub fn digits_to_int(digits: List(Int)) -> Int {
  digits |> list.map(int.to_string) |> string.concat |> parse_int
}

pub fn compare(left: List(Int), right: List(Int)) -> order.Order {
  let zipped = list.zip(left, right)
  let any_gt =
    zipped
    |> list.any(fn(p) {
      let #(a, b) = p
      a > b
    })
  let match = left == right
  case any_gt, match {
    True, _ -> order.Gt
    _, True -> order.Eq
    _, _ -> order.Lt
  }
}

pub fn add_digits(so_far: List(Int), b: List(Int)) -> List(Int) {
  list.zip(so_far, b)
  |> list.map(fn(x) {
    let #(l, r) = x
    l + r
  })
}

pub fn solve2(input: String) -> Int {
  let parsed = input |> parse
  let assert Ok(sum) =
    parsed
    |> list.map(solve_machine_joltage)
    |> list.reduce(int.add)
  sum
}

pub type ButtonWithNumPresses {
  ButtonWithNumPresses(num_presses: Int, button: ButtonOnesAndZeroes)
}

pub fn how_many_fit(button: ButtonOnesAndZeroes, goal: List(Int)) -> Int {
  let assert Ok(largest_n) = goal |> list.max(int.compare)
  let result =
    list.range(0, largest_n)
    |> list.filter(fn(n) {
      let multiplied = button |> list.map(fn(digit) { digit * n })
      case compare(multiplied, goal) {
        order.Eq -> True
        order.Lt -> True
        order.Gt -> False
      }
    })
    |> list.max(int.compare)
  case result {
    Ok(n) -> n
    Error(_) -> 0
  }
}
