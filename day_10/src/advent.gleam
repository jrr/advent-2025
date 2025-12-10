import gleam/bool
import gleam/int
import gleam/io
import gleam/list
import gleam/string

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

// pub fn solve(input: String) -> Int {
//   input
//   |> string.split("\n")
//   |> list.filter(fn(x) { bool.negate(string.is_empty(x)) })
//   |> list.map(parse)
//   |> list.fold(0, fn(a, b) { a + b })
// }

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
// pub fn solve2(input: String) -> Int {
//   solve(input)
// }
