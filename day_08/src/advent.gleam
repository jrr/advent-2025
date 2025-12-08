import gleam/bool
import gleam/dict
import gleam/float
import gleam/int
import gleam/io
import gleam/list
import gleam/order
import gleam/pair
import gleam/set
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

pub type CircuitMembershipMap =
  dict.Dict(Point3, String)

pub type PointPair =
  #(Point3, Point3)

pub type ConnectivitySet =
  set.Set(PointPair)

pub type ConnectivityList =
  List(PointPair)

pub fn normalize_point_pair(pp: PointPair) -> PointPair {
  let #(a, b) = pp
  let assert [x, y] = [a, b] |> list.sort(compare_points)
  #(x, y)
}

fn compare_points(a: Point3, b: Point3) -> order.Order {
  case int.compare(a.x, b.x) {
    order.Eq -> {
      case int.compare(a.y, b.y) {
        order.Eq -> {
          int.compare(a.z, b.z)
        }
        other -> other
      }
    }
    other -> other
  }
}

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

pub type HowFar {
  NumRounds(Int)
  UntilOneCircuit
}

pub fn solve1(input: String, how_far: HowFar) -> #(Int, Int) {
  let points = parse(input)
  let circuits: CircuitMembershipMap =
    points
    |> list.index_map(fn(p, i) { #(p, "C" <> int.to_string(i)) })
    |> dict.from_list

  let candidate_joins =
    circuits
    |> to_points
    |> list.combination_pairs
    |> list.map(fn(pair) {
      let #(a, b) = pair
      #(a.point, b.point)
    })

  let closest_first =
    candidate_joins
    |> list.sort(fn(pair1, pair2) {
      let #(a1, b1) = pair1
      let #(a2, b2) = pair2
      let d1 = distance(a1, b1)
      let d2 = distance(a2, b2)
      float.compare(d1, d2)
    })

  let #(new_circuits, connections) =
    recurse(closest_first, circuits, [] |> set.from_list, [], how_far)

  let circuit_names = new_circuits |> dict.values

  let lengths =
    circuit_names
    |> list.group(by: fn(g) { g })
    |> dict.values
    |> list.map(list.length)
    |> list.sort(order.reverse(int.compare))
    |> list.take(3)

  let assert Ok(product) = lengths |> list.reduce(int.multiply)

  let assert Ok(last_box) = connections |> list.first

  #(product, { last_box.0 }.x * { last_box.1 }.x)
}

fn recurse(
  closest_first: List(#(Point3, Point3)),
  circuits: CircuitMembershipMap,
  connectivity_set: ConnectivitySet,
  connectivity_list: ConnectivityList,
  how_far: HowFar,
) -> #(CircuitMembershipMap, ConnectivityList) {
  // echo num_desired_connections as "countdown"
  case how_far {
    NumRounds(0) -> #(circuits, connectivity_list)
    how_far -> {
      case closest_first {
        [] -> panic
        [top_join, ..tail] -> {
          let normalized_pair =
            normalize_point_pair(#({ top_join.0 }, { top_join.1 }))
          let assert Ok(label_a) = circuits |> dict.get(top_join.0)
          let assert Ok(label_b) = circuits |> dict.get(top_join.1)

          let merged = merge_circuits(circuits, label_a, label_b)

          let num_circuits = merged |> dict.values |> list.unique |> list.length

          let new_connectivity_set =
            connectivity_set |> set.insert(normalized_pair)
          // echo normalized_pair as "new connection"
          let new_connectivity_list = [normalized_pair, ..connectivity_list]

          let go_until = case how_far {
            UntilOneCircuit -> UntilOneCircuit
            NumRounds(n) -> NumRounds(n - 1)
          }

          case list.length(tail), num_circuits {
            0, _ -> #(merged, new_connectivity_list)
            _, 1 -> #(merged, new_connectivity_list)
            _, _ ->
              recurse(
                tail,
                merged,
                new_connectivity_set,
                new_connectivity_list,
                go_until,
              )
          }
        }
      }
    }
  }
}

pub fn merge_circuits(
  circuits: CircuitMembershipMap,
  label_a: String,
  label_b: String,
) -> CircuitMembershipMap {
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

fn to_map(input: List(LabeledPoint)) -> CircuitMembershipMap {
  input |> list.map(fn(p) { #(p.point, p.label) }) |> dict.from_list
}

pub fn solve2(input: String) -> Int {
  0
}
