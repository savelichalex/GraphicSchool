open Pixellib

type bezier_cubic_curve = {
  p1: point;
  p2: point;
  p3: point;
  p4: point;
}

let draw_line_from_curve { p1; p4 } = 
  Brezenham.line p1 p4

let is_straight { p1; p2; p3; p4 } = 
  let tol = 10
  and ax = abs (3 * p2.x - 2 * p1.x - p4.x)
  and ay = abs (3 * p2.y - 2 * p1.y - p4.y)
  and bx = abs (3 * p3.x - p1.x - 2 * p4.x)
  and by = abs (3 * p3.y - p1.y - 2 * p4.y) in
  ((max ax bx) + (max ay by)) <= tol

let get_midpoint p1 p2 = { x = (p1.x + p2.x) / 2; y = (p1.y + p2.y) / 2 }

(* let get_curve_midpoints = function
 *   | p1::p2::[] -> (get_midpoint p1 p2)
 *   | p1::p2::p3::[] -> get_midpoint p1 p2, get_midpoint p2 p3
 *   | p1::p2::p3::p4::[] -> (get_midpoint p1 p2, get_midpoint p2 p3, get_midpoint p3 p4) *)

let get_curve_midpoints_2 p1 p2 = get_midpoint p1 p2
let get_curve_midpoints_3 p1 p2 p3 = (get_midpoint p1 p2, get_midpoint p2 p3)
let get_curve_midpoints_4 p1 p2 p3 p4 = (get_midpoint p1 p2, get_midpoint p2 p3, get_midpoint p3 p4)

let subdivide_curve { p1; p2; p3; p4 } =
  let (m0, m1, m2) = get_curve_midpoints_4 p1 p2 p3 p4 in
  let (q0, q1) = get_curve_midpoints_3 m0 m1 m2 in
  let b = get_curve_midpoints_2 q0 q1 in
  ({ p1 = p1; p2 = m0; p3 = q0; p4 = b }, { p1 = b; p2 = q1; p3 = m2; p4 = p4 })      

let print_curve { p1; p2; p3; p4 } =
  Printf.printf "Curve { (%d, %d), (%d, %d), (%d, %d), (%d, %d)}" p1.x p1.y p2.x p2.y p3.x p3.y p4.x p4.y;
  print_newline ()

let rec draw_cubic_bezier curve =
  if (is_straight curve) then draw_line_from_curve curve
  else begin
    let (left_curve, right_curve) = subdivide_curve curve in
      (* DEBUG
       * print_string "--- Subdivide\n";
       * print_curve left_curve;
       * print_curve right_curve;
       * print_string "--- Subdivide end\n"; *)
      draw_cubic_bezier left_curve;
      draw_cubic_bezier right_curve
  end

let () =
  open_display_buffer_exp ();
  draw_cubic_bezier 
    { p1={x=10; y=10};
      p2={x=60; y=10};
      p3={x=40; y=100};
      p4={x=100; y=100} }
