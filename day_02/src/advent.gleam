import gleam/bool
import gleam/int
import gleam/io
import gleam/list
import gleam/option
import gleam/order
import gleam/string

pub fn main() -> Nil {
  io.println("Hello from advent!")
}

fn parse_int(s: String) -> Int {
  let assert Ok(x) = int.parse(s)
  x
}

pub fn parse(s: String) -> #(Int, Int) {
  let assert [x, y] = string.split(s, "-") |> list.map(parse_int)
  #(x, y)
}

pub fn solve(input: String, is_invalid) -> Int {
  input
  |> string.split(",")
  |> list.filter(fn(x) { bool.negate(string.is_empty(x)) })
  |> list.map(parse)
  |> list.flat_map(fn(range) { list.range(range.0, range.1) })
  |> list.filter(is_invalid)
  |> list.fold(0, fn(a, b) { a + b })
}

pub fn is_invalid1(n: Int) -> Bool {
  let s = int.to_string(n)

  let len = string.length(s)
  case len {
    n if n % 2 != 0 -> False
    _ -> {
      let left = s |> string.drop_start(len / 2)
      let right = s |> string.drop_end(len / 2)
      case string.compare(left, right) {
        order.Eq -> True
        _ -> False
      }
    }
  }
}

pub fn split_evenly(s: String, n: Int) -> option.Option(List(String)) {
  case int.modulo(string.length(s), n) {
    Ok(0) -> {
      let bite_size = string.length(s) / n
      let result =
        list.repeat(Nil, n)
        |> list.fold(#(s, []), fn(accum, _) {
          let #(s, l) = accum
          let word = s |> string.slice(0, bite_size)
          let remainder = s |> string.drop_start(bite_size)

          #(remainder, [word, ..accum.1])
        })
      result.1 |> list.reverse |> option.Some
    }
    _ -> option.None
  }
}

pub fn is_invalid2(n: Int) -> Bool {
  let s = n |> int.to_string
  case string.length(s) {
    1 -> False
    _ -> {
      // todo: narrower
      let range = list.range(2, string.length(s))
      range
      |> list.map(fn(n) {
        let splits = split_evenly(s, n)
        splits
        |> option.map(fn(splits) {
          let num_splits = splits |> list.length
          let num_uniques = splits |> list.unique |> list.length
          // echo #(num_splits, num_uniques) as "num_splits, num_uniques"
          case num_splits, num_uniques {
            1, _ -> False
            _, 1 -> True
            _, _ -> False
          }
        })
      })
      |> list.any(fn(x) {
        case x {
          option.None -> False
          option.Some(b) -> b
        }
      })
    }
  }
}

pub fn solve1(input: String) -> Int {
  solve(input, is_invalid1)
}

pub fn solve2(input: String) -> Int {
  solve(input, is_invalid2)
}
