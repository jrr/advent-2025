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

pub fn solve(input: String) -> Int {
  let #(ops, nums) = input |> parse
  // let foo = ops |> list.index_map(fn (op){

  // })
  let sorted = sort(#(ops, nums))
  // echo sorted
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

pub fn solve1(input: String) -> Int {
  solve(input)
}

pub fn solve2(input: String) -> Int {
  solve(input)
}
