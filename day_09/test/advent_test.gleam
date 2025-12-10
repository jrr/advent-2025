import advent.{
  LineSegment, Point2, RectangleCorners, does_not_intersect_any_lines, parse,
  solve1, solve2,
}
import gleam/list
import gleeunit
import gleeunit/should
import input

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn parse_test() {
  input.example
  |> parse
  |> list.map(fn(p) { #(p.x, p.y) })
  |> should.equal([
    #(7, 1),
    #(11, 1),
    #(11, 7),
    #(9, 7),
    #(9, 5),
    #(2, 5),
    #(2, 3),
    #(7, 3),
  ])
}

pub fn example_1_test() {
  input.example |> solve1 |> should.equal(50)
}

pub fn problem_1_test() {
  input.problem |> solve1 |> should.equal(4_763_040_296)
}

pub fn example_2_test() {
  input.example |> solve2 |> should.equal(24)
}

pub fn problem_2_test() {
  input.problem |> solve2 |> should.equal(1_396_494_456)
}

pub fn rectangle_intersect_line_test() {
  let rectangle =
    RectangleCorners(Point2(15_822, 84_037), Point2(83_178, 15_240))
  let line = LineSegment(Point2(2401, 48_695), Point2(94_969, 48_695))
  does_not_intersect_any_lines(rectangle, [line.start, line.end])
  |> should.equal(False)
}
