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

pub type Point2 {
  Point2(x: Int, y: Int)
}

pub type LineSegment {
  LineSegment(start: Point2, end: Point2)
}

pub type RectangleCorners {
  RectangleCorners(a: Point2, b: Point2)
}

pub fn parse(s: String) -> List(Point2) {
  s
  |> string.split("\n")
  |> list.filter(fn(x) { bool.negate(string.is_empty(x)) })
  |> list.map(fn(line) {
    let parts = line |> string.trim() |> string.split(",")
    let assert [x, y] = parts |> list.map(parse_int)
    Point2(x, y)
  })
}

pub fn rectangle_area(corners: RectangleCorners) -> Int {
  let RectangleCorners(p1, p2) = corners
  let area1 = int.absolute_value(p1.x - p2.x) + 1
  let area2 = int.absolute_value(p1.y - p2.y) + 1
  area1 * area2
}

pub fn solve1(input: String) -> Int {
  let assert Ok(largest) =
    input
    |> parse
    |> list.combination_pairs
    |> list.map(fn(p) { RectangleCorners(p.0, p.1) })
    |> list.max(fn(a, b) { int.compare(rectangle_area(a), rectangle_area(b)) })

  rectangle_area(largest)
}

pub fn solve2(input: String) -> Int {
  let points = input |> parse
  let pairs =
    points
    |> list.combination_pairs
    |> list.map(fn(p) { RectangleCorners(p.0, p.1) })

  let assert Ok(top) =
    pairs
    |> list.filter(fn(p) { does_not_contain_any_points(p, points) })
    |> list.filter(fn(p) { does_not_intersect_any_lines(p, points) })
    |> list.max(fn(a, b) { int.compare(rectangle_area(a), rectangle_area(b)) })

  rectangle_area(top)
}

pub fn does_not_intersect_any_lines(
  corners: RectangleCorners,
  points: List(Point2),
) -> Bool {
  let contained_lines =
    points |> list.window_by_2 |> list.map(fn(l) { LineSegment(l.0, l.1) })
  let assert Ok(first_point) = points |> list.first
  let assert Ok(last_point) = points |> list.last
  let last_line = LineSegment(last_point, first_point)
  let lines = [last_line, ..contained_lines]

  lines
  |> list.any(fn(line) { line_passes_through_rectangle(corners, line) })
  |> bool.negate
}

// Check if a line segment passes through the interior of a rectangle
// (not just touching the boundary)
fn line_passes_through_rectangle(
  corners: RectangleCorners,
  line: LineSegment,
) -> Bool {
  let RectangleCorners(Point2(x_min, y_min), Point2(x_max, y_max)) = corners
  // Ensure min/max order
  let rect_x_min = int.min(x_min, x_max)
  let rect_x_max = int.max(x_min, x_max)
  let rect_y_min = int.min(y_min, y_max)
  let rect_y_max = int.max(y_min, y_max)

  let LineSegment(Point2(x1, y1), Point2(x2, y2)) = line

  // Simple check: does the line cross through the rectangle?
  // A horizontal/vertical line passes through if it spans the rectangle
  // and its other coordinate is within the rectangle bounds

  // Check for horizontal line
  let is_horizontal = y1 == y2
  let horizontal_passes =
    is_horizontal
    && y1 > rect_y_min
    && y1 < rect_y_max
    // y is strictly inside rectangle
    && int.min(x1, x2) < rect_x_max
    && int.max(x1, x2) > rect_x_min
  // line spans rectangle in x

  // Check for vertical line
  let is_vertical = x1 == x2
  let vertical_passes =
    is_vertical
    && x1 > rect_x_min
    && x1 < rect_x_max
    // x is strictly inside rectangle
    && int.min(y1, y2) < rect_y_max
    && int.max(y1, y2) > rect_y_min
  // line spans rectangle in y

  // For diagonal lines, check if line passes through rectangle interior
  let diagonal_passes =
    !is_horizontal
    && !is_vertical
    && {
      // Check if either endpoint is strictly inside
      let p1_inside =
        x1 > rect_x_min && x1 < rect_x_max && y1 > rect_y_min && y1 < rect_y_max
      let p2_inside =
        x2 > rect_x_min && x2 < rect_x_max && y2 > rect_y_min && y2 < rect_y_max

      // Or if line crosses from one side to another (simplified check)
      let crosses_x =
        { x1 <= rect_x_min && x2 >= rect_x_max }
        || { x1 >= rect_x_max && x2 <= rect_x_min }
      let crosses_y =
        { y1 <= rect_y_min && y2 >= rect_y_max }
        || { y1 >= rect_y_max && y2 <= rect_y_min }

      p1_inside || p2_inside || { crosses_x && crosses_y }
    }

  horizontal_passes || vertical_passes || diagonal_passes
}

fn does_not_contain_any_points(
  corners: RectangleCorners,
  points: List(Point2),
) -> Bool {
  points
  |> list.any(fn(p) { point_inside_rectangle(corners, p) })
  |> bool.negate
}

fn point_inside_rectangle(corners: RectangleCorners, p: Point2) -> Bool {
  let point_between_x = case { corners.a }.x, p.x, { corners.b }.x {
    a, b, c if a < b && b < c -> True
    a, b, c if a > b && b > c -> True
    _, _, _ -> False
  }

  let point_between_y = case { corners.a }.y, p.y, { corners.b }.y {
    a, b, c if a < b && b < c -> True
    a, b, c if a > b && b > c -> True
    _, _, _ -> False
  }
  point_between_x && point_between_y
}
