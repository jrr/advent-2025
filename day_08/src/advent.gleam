import gleam/bool
import gleam/int
import gleam/io
import gleam/list
import gleam/string

pub fn main() -> Nil {
  io.println("Hello from advent!")
}

pub type Point3 {
  Point3(x: Int, y: Int, z: Int)
}

fn parse_int(s: String) -> Int {
  let assert Ok(x) = int.parse(s)
  x
}

pub fn parse(s: String) -> List(Point3) {
  s
  |> string.split("\n")
  |> list.filter(fn(line) { bool.negate(string.is_empty(line)) })
  |> list.map(fn(line) {
    let parts = line |> string.trim() |> string.split(",")
    let assert [x, y, z] = parts |> list.map(parse_int)
    Point3(x, y, z)
  })
}

pub fn solve1(input: String) -> Int {
  0
}

pub fn solve2(input: String) -> Int {
  0
}
