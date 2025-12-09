import advent.{
  LineSegment, Point2, line_segments_intersect, parse, solve1, solve2,
  does_not_intersect_any_lines
}
import gleeunit
import gleeunit/should
import input

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn parse_test() {
  input.example
  |> parse
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
  input.problem |> solve2 |> should.equal(1396494456)
}

pub fn line_segments_intersect_test() {
  // Test 1: X shape (should still intersect - proper crossing)
  #(
    LineSegment(Point2(0, 0), Point2(2, 2)),
    LineSegment(Point2(0, 2), Point2(2, 0)),
  )
  |> line_segments_intersect
  |> should.equal(True)

  // Test 2: parallel (should NOT intersect)
  #(
    LineSegment(Point2(0, 0), Point2(2, 0)),
    LineSegment(Point2(0, 1), Point2(2, 1)),
  )
  |> line_segments_intersect
  |> should.equal(False)

  // Test 3: colinear disconnected
  #(
    LineSegment(Point2(0, 0), Point2(1, 1)),
    LineSegment(Point2(2, 2), Point2(3, 3)),
  )
  |> line_segments_intersect
  |> should.equal(False)

  // Test 4: touching at ends (no longer counts as intersection)
  #(
    LineSegment(Point2(0, 0), Point2(1, 1)),
    LineSegment(Point2(1, 1), Point2(2, 0)),
  )
  |> line_segments_intersect
  |> should.equal(False)

  // Test 5: overlapping colinear (no longer counts as intersection)
  #(
    LineSegment(Point2(0, 0), Point2(2, 0)),
    LineSegment(Point2(1, 0), Point2(3, 0)),
  )
  |> line_segments_intersect
  |> should.equal(False)

  // Test 6: plus sign
  #(
    LineSegment(Point2(5, 1), Point2(5, 10)),
    LineSegment(Point2(1, 5), Point2(10, 5)),
  )
  |> line_segments_intersect
  |> should.equal(True)

  // Test 7: disconnected perpendicular
  #(
    LineSegment(Point2(1, 1), Point2(10, 1)),
    LineSegment(Point2(3, 3), Point2(3, 10)),
  )
  |> line_segments_intersect
  |> should.equal(False)
}


pub fn rectangle_intersect_line_test() {
  let rectangle = #(#(15_822, 84_037), #(83_178, 15_240))
  let line = #(#(2401, 48_695), #(94_969, 48_695))
  does_not_intersect_any_lines(rectangle,[line.0,line.1])
  |> should.equal(False)
}
