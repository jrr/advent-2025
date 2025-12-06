import gleam/bool
import gleam/int
import gleam/io
import gleam/list
import gleam/string

pub fn main() -> Nil {
  io.println("Hello from advent!")
}

fn parse_int(s: String) -> Int {
  let assert Ok(x) = int.parse(s)
  x
}

pub type Operation {
  Add
  Multiply
}

fn parse_op(string: String) -> Operation {
  case string {
    "+" -> Add
    "*" -> Multiply
    _ -> panic
  }
}

pub fn is_not_empty(s: String) {
  bool.negate(string.is_empty(s))
}

pub fn parse(s: String) {
  let lines =
    s
    |> string.split("\n")
    |> list.filter(is_not_empty)
  let len = lines |> list.length
  let lines_of_cols =
    lines
    |> list.map(fn(line) {
      line |> string.split(" ") |> list.filter(is_not_empty)
    })
  let #(a, b) = lines_of_cols |> list.split(len - 1)
  let assert [ops] = b
  let nums = a |> list.map(fn(s) { s |> list.map(parse_int) })
  let operations = ops |> list.map(parse_op)

  #(operations, nums)
}

pub fn solve1(input: String) -> Int {
  input
  |> parse
  |> sort
  |> do_arithmetic
}

fn do_arithmetic(sorted: List(#(Operation, List(Int)))) -> Int {
  let assert Ok(answer) =
    sorted
    |> list.map(fn(group) {
      let #(op, nums) = group

      let assert Ok(what) =
        nums
        |> list.reduce(fn(a, b) {
          case op {
            Add -> a + b
            Multiply -> a * b
          }
        })
      what
    })
    |> list.reduce(int.add)
  answer
}

pub fn sort(
  ops_nums: #(List(Operation), List(List(Int))),
) -> List(#(Operation, List(Int))) {
  let #(ops, nums) = ops_nums
  let seed =
    ops
    |> list.map(fn(op) {
      let empty_int_list: List(Int) = []
      #(op, empty_int_list)
    })
  let sorted =
    nums
    |> list.fold(seed, fn(accum, row_of_nums) {
      list.zip(accum, row_of_nums)
      |> list.map(fn(z) {
        let #(#(op, num_list), new_num) = z
        #(op, [new_num, ..num_list])
      })
    })
  sorted
}

pub fn solve2(input: String) -> Int {
  let lines =
    input
    |> string.split("\n")
    |> list.filter(is_not_empty)
  let number_of_lines = lines |> list.length
  let #(digit_lines, op_lines) = lines |> list.split(number_of_lines - 1)

  let assert [op_line] = op_lines
  let ops =
    op_line
    |> string.split(" ")
    |> list.filter(is_not_empty)
    |> list.map(parse_op)
  let assert Ok(line_length) =
    lines |> list.map(string.length) |> list.max(int.compare)
  let empties = list.repeat("", line_length)
  let digit_groups =
    digit_lines
    |> list.fold(empties, fn(accum, line) {
      let char_list = line |> string.to_graphemes
      list.zip(accum, char_list)
      |> list.map(fn(tuple) {
        let #(a, b) = tuple
        a <> b
      })
    })
    |> list.map(string.trim)
    |> split_on_empty_strings
    |> list.map(fn(group) { group |> list.map(parse_int) })
  let pairs = list.zip(ops, digit_groups)
  let assert Ok(answer) =
    pairs
    |> list.map(fn(tuple) {
      let #(op, nums) = tuple
      let assert Ok(result) =
        nums
        |> list.reduce(fn(a, b) {
          case op {
            Add -> a + b
            Multiply -> a * b
          }
        })
      result
    })
    |> list.reduce(int.add)
  answer
}

fn split_on_empty_strings(strings: List(String)) -> List(List(String)) {
  let #(a, b) = strings |> list.split_while(fn(s) { s != "" })
  case a, b {
    a, [] -> [a]
    a, ["", ..b] -> [a] |> list.append(split_on_empty_strings(b))
    a, b -> [a] |> list.append(split_on_empty_strings(b))
  }
}
