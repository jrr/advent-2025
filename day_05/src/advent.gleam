import gleam/bool
import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import gleam/string

pub fn main() -> Nil {
  io.println("Hello from advent!")
}

pub type Input {
  FreshRange(#(Int, Int))
  ItemNumber(number: Int)
}

pub fn parse_lines(s: String) -> List(Input) {
  s
  |> string.split("\n")
  |> list.filter(fn(x) { bool.negate(string.is_empty(x)) })
  |> list.map(string.trim)
  |> list.map(fn(line) {
    case string.contains(line, "-") {
      True -> {
        let assert [left, right] = string.split(line, "-")
        let assert Ok(start) = int.parse(left)
        let assert Ok(end) = int.parse(right)
        FreshRange(#(start, end))
      }
      False -> {
        let assert Ok(n) = int.parse(line)
        ItemNumber(n)
      }
    }
  })
}

pub fn range_contains(range: #(Int, Int), item: Int) -> Bool {
  let #(start, end) = range
  item >= start && item <= end
}

pub fn parse(input: String) {
  let parsed = parse_lines(input)
  let ranges =
    parsed
    |> list.filter(fn(x) {
      case x {
        FreshRange(_) -> True
        _ -> False
      }
    })
    |> list.map(fn(x) {
      case x {
        FreshRange(r) -> r
        _ -> panic
      }
    })

  let items =
    parsed
    |> list.filter(fn(x) {
      case x {
        ItemNumber(_) -> True
        _ -> False
      }
    })
    |> list.map(fn(x) {
      case x {
        ItemNumber(n) -> n
        _ -> panic
      }
    })
  #(ranges, items)
}

pub fn solve1(input: String) -> Int {
  let #(ranges, items) = parse(input)

  let foo =
    items
    |> list.filter(fn(item) {
      ranges
      |> list.any(fn(range) { range_contains(range, item) })
    })
  foo |> list.length
}

pub fn solve2(input: String) -> Int {
  let #(ranges, _) = parse(input)
  let assert Ok(what) =
    ranges
    |> merge_ranges
    |> merge_ranges
    |> merge_ranges
    |> merge_ranges
    |> list.sort(fn(a, b) { int.compare(a.0, b.0) })
    |> list.map(fn(r) { r.1 - r.0 + 1 })
    |> list.reduce(int.add)
  what
}

pub fn ranges_overlap(a: #(Int, Int), b: #(Int, Int)) -> Bool {
  range_contains(a, b.0) || range_contains(a, b.1)
}

pub fn combine_ranges(a: #(Int, Int), b: #(Int, Int)) -> #(Int, Int) {
  #(int.min(a.0, b.0), int.max(a.1, b.1))
}

pub fn merge_all_ranges(ranges: List(#(Int, Int))) -> #(Int, Int) {
  let assert Ok(answer) =
    ranges
    |> list.reduce(fn(a, b) { combine_ranges(a, b) })
  answer
}

pub fn sort_into_two_groups(
  input: List(value),
  sorter: fn(value) -> Bool,
) -> #(List(value), List(value)) {
  let what = input |> list.group(sorter)
  let matches = case what |> dict.get(True) {
    Ok(m) -> m
    Error(_) -> []
  }
  let non_matches = case what |> dict.get(False) {
    Ok(nm) -> nm
    Error(_) -> []
  }

  #(matches, non_matches)
}

pub fn merge_ranges(ranges: List(#(Int, Int))) -> List(#(Int, Int)) {
  let merged =
    ranges
    |> list.fold([], fn(accum, b) {
      let #(matches, non_matches) =
        accum |> sort_into_two_groups(fn(a) { ranges_overlap(a, b) })
      let single_merged_range = merge_all_ranges([b, ..matches])
      list.append([single_merged_range], non_matches)
    })
    |> list.sort(fn(a, b) { int.compare(a.0, b.0) })

  merged
}
