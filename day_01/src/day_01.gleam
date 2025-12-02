import gleam/int
import gleam/io
import gleam/list
import gleam/string

pub fn main() -> Nil {
  io.println("Hello from day_01!")
}

pub type Direction {
  Left
  Right
}

pub type Motion {
  Motion(num: Int, direction: Direction)
}

pub fn parse(s: String) -> Motion {
  let a = case s {
    "L" <> num -> #(Left, int.parse(num))
    "R" <> num -> #(Right, int.parse(num))
    _ -> panic
  }

  case a.0, a.1 {
    dir, Ok(n) -> Motion(num: n, direction: dir)
    _, _ -> panic
  }
}

pub type IntermediateState {
  IntermediateState(position: Int, zero_count: Int)
}

const initial_state = IntermediateState(50, 0)

pub fn motion_to_num(motion: Motion) -> Int {
  case motion {
    Motion(n, Left) -> -1 * n
    Motion(n, Right) -> n
  }
}

pub fn solve(input: String) -> Int {
  input
  |> string.split("\n")
  |> list.map(parse)
  |> list.map(motion_to_num)
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

pub fn solve2(input: String) -> Int {
  input
  |> string.split("\n")
  |> list.map(parse)
  |> list.map(motion_to_num)
  |> list.flat_map(fn(n) {
    case n {
      n if n > 0 -> list.repeat(1, n)
      n if n < 0 -> list.repeat(-1, n * -1)
      _ -> panic
    }
  })
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
