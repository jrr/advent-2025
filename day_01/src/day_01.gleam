import gleam/int
import gleam/io
import gleam/list
import gleam/string

pub fn main() -> Nil {
  io.println("Hello from day_01!")
}

fn parse_int(s: String) -> Int {
  let assert Ok(x) = int.parse(s)
  x
}

pub fn parse(s: String) -> Int {
  case s {
    "L" <> num -> -parse_int(num)
    "R" <> num -> parse_int(num)
    _ -> panic
  }
}

pub type IntermediateState {
  IntermediateState(position: Int, zero_count: Int)
}

const initial_state = IntermediateState(50, 0)

pub fn solve1(input: String) -> Int {
  solve(input, False)
}

pub fn solve2(input: String) -> Int {
  solve(input, True)
}

fn expand_motion(motion: Int) -> List(Int) {
  case motion {
    n if n > 0 -> list.repeat(1, n)
    n if n < 0 -> list.repeat(-1, int.absolute_value(n))
    _ -> panic
  }
}

pub fn solve(input: String, expand: Bool) -> Int {
  input
  |> string.split("\n")
  |> list.map(parse)
  |> fn(motions) {
    case expand {
      True -> list.flat_map(motions, expand_motion)
      False -> motions
    }
  }
  |> list.fold(initial_state, fn(state, motion) {
    let assert Ok(new_pos) = int.modulo(state.position + motion, 100)
    let x = case new_pos {
      0 -> 1
      _ -> 0
    }
    let new_count = state.zero_count + x

    let new_state = IntermediateState(new_pos, new_count)
    new_state
  })
  |> fn(state) { state.zero_count }
}
