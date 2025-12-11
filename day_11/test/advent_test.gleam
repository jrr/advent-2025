import advent.{clean_tree, find_entries, parse, parse_line, reverse_dict, solve1}
import gleam/dict
import gleam/io
import gleam/list
import gleeunit
import input

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn parse_test() {
  assert "bbb: ddd eee" |> parse_line == #("bbb", ["ddd", "eee"])
}

pub fn example_2_test() {
  let results = input.example2 |> solve1("svr", "out")
  assert results.num_paths_with_fft_and_dac == 2
}

pub fn problem_2_test() {
  let results = input.problem |> solve1("svr", "out")
  assert results.num_paths_with_fft_and_dac == 553204221431080
}

fn print_mermaid(input: dict.Dict(String, List(String))) {
  input
  |> dict.to_list
  |> list.map(fn(x) {
    let #(a, b) = x
    b |> list.map(fn(bb) { io.println(a <> " --> " <> bb) })
  })
}

pub fn reverse_dict_test() {
  // a points to b and c; b points to c
  let input = dict.from_list([#("a", ["b", "c"]), #("b", ["c"])])

  // b is pointed-to by a, c is pointed-to by a and b, a is pointed-to by nobody
  let expected = dict.from_list([#("b", ["a"]), #("c", ["b", "a"]), #("a", [])])

  assert input |> reverse_dict == expected
}

pub fn find_entries_test() {
  assert input.example |> parse |> find_entries == ["aaa"]
  assert input.example2 |> parse |> find_entries == ["svr"]
  assert input.problem |> parse |> find_entries == ["svr"]
}

pub fn clean_tree_test() {
  let tree = input.example |> parse
  let result = clean_tree(tree, "you")

  let num_yous =
    result |> dict.values |> list.flatten |> list.count(fn(s) { s == "you" })
  assert num_yous == 0
}
