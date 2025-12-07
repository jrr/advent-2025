import gleam/bool
import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import gleam/string

pub fn main() -> Nil {
  io.println("Hello from advent!")
}

pub fn parse_first_line(line: String) -> dict.Dict(Int, TachyonState) {
  line
  |> string.to_graphemes
  |> list.index_map(fn(c, i) {
    let b = case c {
      "S" -> Paths(1)
      _ -> None
    }
    #(i, b)
  })
  |> dict.from_list
}

pub type TachyonState {
  None
  Paths(Int)
}

pub type State {
  State(tachyons: dict.Dict(Int, TachyonState), num_splits: Int)
}

pub fn solve(input: String) -> #(Int, Int) {
  let lines =
    input
    |> string.split("\n")
    |> list.filter(fn(x) { bool.negate(string.is_empty(x)) })
  let assert [head, ..tail] = lines
  let initial_state = State(parse_first_line(head), 0)

  let final_state =
    tail
    |> list.fold(initial_state, fn(state, line) {
      let updates =
        line
        |> string.to_graphemes
        |> list.index_map(fn(c, i) {
          let incoming_tachyon = state.tachyons |> dict.get(i)
          let #(new_pairs, num_new_splits) = case incoming_tachyon, c {
            Ok(None), _ -> #([], 0)
            Ok(Paths(n)), "." -> #([#(i, Paths(n))], 0)
            Ok(Paths(n)), "^" -> #([#(i - 1, Paths(n)), #(i + 1, Paths(n))], 1)
            _, _ -> #([], 0)
          }
          #(new_pairs, num_new_splits)
        })

      let new_dict = build_new_dict(updates)

      let assert Ok(new_count) =
        updates |> list.map(fn(u) { u.1 }) |> list.reduce(int.add)

      State(new_dict, state.num_splits + new_count)
    })

  #(final_state.num_splits, count_paths(final_state))
}

fn build_new_dict(
  updates: List(#(List(#(Int, TachyonState)), Int)),
) -> dict.Dict(Int, TachyonState) {
  let assert Ok(new_dict) =
    updates
    |> list.map(fn(x) { x.0 |> dict.from_list })
    |> list.reduce(fn(a, b) {
      dict.combine(a, b, fn(a, b) {
        case a, b {
          None, None -> None
          None, Paths(x) -> Paths(x)
          Paths(x), None -> Paths(x)
          Paths(x), Paths(y) -> Paths(x + y)
        }
      })
    })
  new_dict
}

fn count_paths(final_state: State) -> Int {
  let assert Ok(num_paths) =
    final_state.tachyons
    |> dict.to_list
    |> list.map(fn(x) {
      case x.1 {
        None -> 0
        Paths(n) -> n
      }
    })
    |> list.reduce(int.add)
  num_paths
}
