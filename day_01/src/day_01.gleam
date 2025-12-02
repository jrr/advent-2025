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

pub fn expand_motion(motion: Int) -> List(Int) {
  let value = motion / int.absolute_value(motion)
  let howmany = int.absolute_value(motion)
  list.repeat(value, howmany)
}

pub type ExpandMode {
  ExpandMotions
  PassThrough
}

pub fn solve(input: String, expand: ExpandMode) -> Int {
  input
  |> string.split("\n")
  |> list.map(parse)
  |> fn(motions) {
    case expand {
      // turn e.g. [3] to [1,1,1] so that we can observe whenever it passes zero
      ExpandMotions -> list.flat_map(motions, expand_motion)
      PassThrough -> motions
    }
  }
  |> list.fold(initial_state, fn(state, motion) {
    let assert Ok(new_pos) = int.modulo({ state.position + motion }, 100)
    let on_zero = case new_pos {
      0 -> 1
      _ -> 0
    }
    let new_count = state.zero_count + on_zero

    IntermediateState(new_pos, new_count)
  })
  |> fn(state) { state.zero_count }
}

pub fn solve1(input: String) -> Int {
  solve(input, PassThrough)
}

pub fn solve2(input: String) -> Int {
  solve(input, ExpandMotions)
}
