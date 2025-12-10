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

// pub fn solve1(input: String) -> Int {
//   solve(input)
// }

// pub fn solve2(input: String) -> Int {
//   solve(input)
// }
