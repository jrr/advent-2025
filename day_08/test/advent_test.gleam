import advent.{
  Point3, distance, merge_circuits, normalize_point_pair, parse, solve1,
}
import gleam/dict
import gleeunit
import gleeunit/should
import input

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn parse_test() {
  "1,2,3
  4,5,6"
  |> parse
  |> should.equal([Point3(1, 2, 3), Point3(4, 5, 6)])
}

pub fn distance_test() {
  let a = Point3(1, 2, 3)
  let b = Point3(4, 5, 6)
  distance(a, b) |> should.equal(5.196152422706632)
}

pub fn num_connections_test() {
  let circuits = [
    [Point3(1, 2, 3), Point3(4, 5, 6)],
    [Point3(5, 2, 3), Point3(5, 5, 6), Point3(9, 9, 9)],
    [Point3(7, 8, 9)],
  ]
  advent.num_connections(circuits) |> should.equal(3)
}

pub fn merge_circuits_test() {
  let input =
    [
      #(Point3(1, 1, 1), "A"),
      #(Point3(2, 2, 2), "B"),
      #(Point3(3, 3, 3), "C"),
    ]
    |> dict.from_list

  let expected =
    [#(Point3(1, 1, 1), "A"), #(Point3(2, 2, 2), "A"), #(Point3(3, 3, 3), "C")]
    |> dict.from_list

  input |> merge_circuits("A", "B") |> should.equal(expected)
}

pub fn normalize_point_pair_test() {
  let p1 = Point3(1, 2, 3)
  let p2 = Point3(2, 3, 4)

  #(p1, p2) |> normalize_point_pair |> should.equal(#(p1, p2))

  #(p2, p1) |> normalize_point_pair |> should.equal(#(p1, p2))
}

pub fn example_1_test() {
  input.example |> solve1(10) |> should.equal(40)
}

pub fn problem_1_test() {
  input.problem |> solve1(1000) |> should.equal(103488)
}

// pub fn example_2_test() {
//   input.example |> solve2 |> should.equal(6)
// }

// pub fn problem_2_test() {
//   input.problem |> solve2 |> should.equal(0)
// }
