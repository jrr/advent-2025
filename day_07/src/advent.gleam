import gleam/bool
import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import gleam/string

pub fn main() -> Nil {
  io.println("Hello from advent!")
}

pub fn parse(s: String) -> Int {
  let assert Ok(n) = int.parse(s)
  n
}

pub fn solve(input: String) -> Int {
  input
  |> string.split("\n")
  |> list.filter(fn(x) { bool.negate(string.is_empty(x)) })
  |> list.map(parse)
  |> list.fold(0, fn(a, b) { a + b })
}

pub fn parse_first_line(line: String) -> dict.Dict(Int, Bool) {
  line
  |> string.to_graphemes
  |> list.index_map(fn(c, i) {
    let b = case c {
      "S" -> True
      // "." -> False
      _ -> False
    }
    #(i, b)
  })
  |> dict.from_list
}

pub type State {
  State(tachyons: dict.Dict(Int, Bool), num_splits: Int)
}

pub fn solve1(input: String) -> Int {
  let lines =
    input
    |> string.split("\n")
    |> list.filter(fn(x) { bool.negate(string.is_empty(x)) })
  let assert [head, ..tail] = lines
  let initial_state = State(parse_first_line(head), 0)

  let final_state =
    tail
    |> list.fold(initial_state, fn(state, line) {
      // let #(old_state,split_count) = accum
      let updates =
        line
        |> string.to_graphemes
        |> list.index_map(fn(c, i) {
          let incoming_tachyon = state.tachyons |> dict.get(i)
          let #(new_pairs, num_new_splits) = case incoming_tachyon, c {
            Ok(True), "." -> #([#(i, True)], 0)
            Ok(True), "^" -> #([#(i - 1, True), #(i + 1, True)], 1)
            _, _ -> #([], 0)
          }
          #(new_pairs, num_new_splits)
        })

      let new_dict =
        updates
        |> list.flat_map(fn(x) { x.0 })
        |> dict.from_list
      let assert Ok(new_count) =
        updates |> list.map(fn(u) { u.1 }) |> list.reduce(int.add)
      State(new_dict, state.num_splits + new_count)
    })
  final_state.num_splits
}

pub fn solve2(input: String) -> Int {
  solve(input)
}
