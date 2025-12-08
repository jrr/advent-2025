import gleam/bool
import gleam/dict
import gleam/float
import gleam/int
import gleam/io
import gleam/list
import gleam/order
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

pub type CircuitMap =
  dict.Dict(Point3, String)

pub type LabeledPoint {
  LabeledPoint(point: Point3, label: String)
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

pub fn distance(a: Point3, b: Point3) -> Float {
  let assert Ok(x) = int.power(a.x - b.x, 2.0)
  let assert Ok(y) = int.power(a.y - b.y, 2.0)
  let assert Ok(z) = int.power(a.z - b.z, 2.0)
  let assert Ok(sq) = float.square_root(x +. y +. z)
  sq
}

pub fn num_connections(circuits: List(List(Point3))) -> Int {
  let assert Ok(n) =
    circuits
    |> list.map(fn(circuit) { list.length(circuit) - 1 })
    |> list.reduce(int.add)
  n
}

pub fn solve1(input: String, num_desired_connections: Int) -> Int {
  let points = parse(input)
  let circuits: CircuitMap =
    points
    |> list.index_map(fn(p, i) { #(p, "C" <> int.to_string(i)) })
    |> dict.from_list

  let new_circuits = recurse(circuits, num_desired_connections)

  let lengths =
    new_circuits
    |> list.map(fn(circuit) { list.length(circuit) })
    |> list.sort(order.reverse(int.compare))
    |> list.take(3)
  echo lengths as "three longest"
  let assert Ok(product) = lengths |> list.reduce(int.multiply)
  product
}

fn recurse(
  circuits: CircuitMap,
  num_desired_connections: Int,
) -> List(List(Point3)) {
  let candidate_joins = circuits |> to_points |> list.combination_pairs
  let assert Ok(top_join) =
    candidate_joins
    |> list.filter(fn(pair) {
      let #(a, b) = pair
      a.label != b.label
    })
    |> list.max(fn(pair1, pair2) {
      let #(a1, b1) = pair1
      let #(a2, b2) = pair2
      let d1 = distance(a1.point, b1.point)
      let d2 = distance(a2.point, b2.point)
      order.negate(float.compare(d1, d2))
    })
  let merged =
    merge_circuits(circuits, { top_join.0 }.label, { top_join.1 }.label)
  todo
}

pub fn merge_circuits(
  circuits: CircuitMap,
  label_a: String,
  label_b: String,
) -> CircuitMap {
  let updates =
    circuits
    |> to_points
    |> list.filter(fn(p) { p.label == label_b })
    |> list.map(fn(p) { LabeledPoint(..p, label: label_a) })
    |> to_map
  dict.merge(circuits, updates)
}

fn to_points(input: dict.Dict(Point3, String)) -> List(LabeledPoint) {
  input
  |> dict.to_list
  |> list.map(fn(kv) {
    let #(point, label) = kv
    LabeledPoint(point, label)
  })
}

fn to_map(input: List(LabeledPoint)) -> CircuitMap {
  input |> list.map(fn(p) { #(p.point, p.label) }) |> dict.from_list
}

pub fn solve2(input: String) -> Int {
  0
}
