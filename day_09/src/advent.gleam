import gleam/bool
import gleam/int
import gleam/io
import gleam/list
import gleam/order
import gleam/string

pub fn main() -> Nil {
  io.println("Hello from advent!")
}

fn parse_int(s: String) -> Int {
  let assert Ok(x) = int.parse(s)
  x
}

pub type Point =
  #(Int, Int)

pub type Point2 {
  Point2(x: Int, y: Int)
}

pub type LineSegment {
  LineSegment(start: Point2, end: Point2)
}

pub type RectangleCorners =
  #(Point, Point)

pub fn parse(s: String) -> List(Point) {
  s
  |> string.split("\n")
  |> list.filter(fn(x) { bool.negate(string.is_empty(x)) })
  |> list.map(fn(line) {
    let parts = line |> string.trim() |> string.split(",")
    let assert [x, y] = parts |> list.map(parse_int)
    #(x, y)
  })
}

pub fn rectangle_area(corners: RectangleCorners) -> Int {
  let #(p1, p2) = corners
  let area1 = int.absolute_value(p1.0 - p2.0) + 1
  let area2 = int.absolute_value(p1.1 - p2.1) + 1
  area1 * area2
}

pub fn solve1(input: String) -> Int {
  let assert Ok(largest) =
    input
    |> parse
    |> list.combination_pairs
    |> list.max(fn(a, b) { int.compare(rectangle_area(a), rectangle_area(b)) })

  rectangle_area(largest)
}

// 28 candidate rectangles in example
// 122760 in real problem

pub fn solve2(input: String) -> Int {
  // all combination pairs
  // filter out rectangles that internally contain any other point
  //   (it's okay for other points to sit along the rectangle's edge)
  // filter out rectangles that intersect any other line segment

  let points = input |> parse
  let pairs = points |> list.combination_pairs

  echo "initial points: " <> int.to_string(pairs |> list.length)

  let assert Ok(top) =
    pairs
    |> list.filter(fn(p) { does_not_contain_any_points(p, points) })
    |> fn(l) {
      echo "narrowed (points): " <> int.to_string(list.length(l))
      l
    }
    |> list.filter(fn(p) { does_not_intersect_any_lines(p, points) })
    |> fn(l) {
      echo "narrowed (edges): " <> int.to_string(list.length(l))
      l
    }
    |> list.max(fn(a, b) { int.compare(rectangle_area(a), rectangle_area(b)) })
  echo top as "top"

  rectangle_area(top)
}

pub fn does_not_intersect_any_lines(
  corners: RectangleCorners,
  points: List(Point),
) -> Bool {
  let contained_lines = points |> list.window_by_2
  let assert Ok(first_point) = points |> list.first
  let assert Ok(last_point) = points |> list.last
  let last_line = #(last_point, first_point)
  let lines =
    [last_line, ..contained_lines]
    |> list.map(fn(z) {
      let #(#(a, b), #(c, d)) = z
      LineSegment(Point2(a, b), Point2(c, d))
    })

  let has_any =
    lines |> list.any(fn(line) { line_intersects_rectangle(corners, line) })
  !has_any
}

fn line_intersects_rectangle(
  corners: #(#(Int, Int), #(Int, Int)),
  line: LineSegment,
) -> Bool {
  let #(#(x1, y1), #(x2, y2)) = corners
  let rectangle_edges =
    [
      #(#(x1, y1), #(x2, y1)),
      #(#(x1, y1), #(x1, y2)),
      #(#(x2, y1), #(x2, y2)),
      #(#(x1, y2), #(x2, y2)),
    ]
    |> list.map(fn(z) {
      let #(#(a, b), #(c, d)) = z
      LineSegment(Point2(a, b), Point2(c, d))
    })

  let any_intersect =
    rectangle_edges
    |> list.any(fn(edge) { line_segments_intersect(#(edge, line)) })
  any_intersect
}

fn does_not_contain_any_points(
  corners: RectangleCorners,
  points: List(Point),
) -> Bool {
  let has_any =
    points
    |> list.any(fn(p) { point_inside_rectangle(corners, p) })
  !has_any
}

fn point_inside_rectangle(
  corners: #(#(Int, Int), #(Int, Int)),
  p: #(Int, Int),
) -> Bool {
  let point_between_x = case corners.0.0, p.0, corners.1.0 {
    a, b, c if a < b && b < c -> True
    a, b, c if a > b && b > c -> True
    _, _, _ -> False
  }

  let point_between_y = case corners.0.1, p.1, corners.1.1 {
    a, b, c if a < b && b < c -> True
    a, b, c if a > b && b > c -> True
    _, _, _ -> False
  }
  point_between_x && point_between_y
}

// Helper function to calculate orientation of ordered triplet (p, q, r)
// Returns 0 if collinear, 1 if clockwise, 2 if counterclockwise
fn orientation(p: Point2, q: Point2, r: Point2) -> Int {
  let val = { q.y - p.y } * { r.x - q.x } - { q.x - p.x } * { r.y - q.y }
  case val {
    0 -> 0
    // collinear
    _ if val > 0 -> 1
    // clockwise
    _ -> 2
    // counterclockwise
  }
}

// Helper function to check if point q lies on line segment
fn on_segment(segment: LineSegment, q: Point2) -> Bool {
  let LineSegment(p, r) = segment
  q.x <= int.max(p.x, r.x)
  && q.x >= int.min(p.x, r.x)
  && q.y <= int.max(p.y, r.y)
  && q.y >= int.min(p.y, r.y)
}

pub fn line_segments_intersect(lines: #(LineSegment, LineSegment)) -> Bool {
  let #(line1, line2) = lines
  let LineSegment(p1, q1) = line1
  let LineSegment(p2, q2) = line2

  let o1 = orientation(p1, q1, p2)
  let o2 = orientation(p1, q1, q2)
  let o3 = orientation(p2, q2, p1)
  let o4 = orientation(p2, q2, q1)

  // Check if lines share endpoint(s) or are collinear
  let shares_endpoints =
    points_equal(p1, p2) || points_equal(p1, q2) ||
    points_equal(q1, p2) || points_equal(q1, q2)

  let are_collinear = o1 == 0 && o2 == 0 && o3 == 0 && o4 == 0

  case shares_endpoints || are_collinear {
    True -> False  // Sharing endpoints or being collinear doesn't count as intersection
    False -> {
      // Only count as intersection if segments properly cross each other
      // (different orientations means they cross)
      o1 != o2 && o3 != o4
    }
  }
}

// Helper to check if two points are equal
fn points_equal(p1: Point2, p2: Point2) -> Bool {
  p1.x == p2.x && p1.y == p2.y
}
// fn does_not_contain_point(
//   points: List(Point),
// ) -> fn(#(Point, Point)) -> Bool {
//   let contains_any = points |> list.any()
//   todo
// }
