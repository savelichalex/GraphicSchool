open Pixellib

let inc a = a + 1
let dec a = a - 1

let get_next_possibility x_or_y p two_dy two_dy_dx modificator =
  if (p < 0) then (x_or_y, p + two_dy)
  else (modificator x_or_y, p + two_dy_dx)

module LessSlope = struct
  let get_initial_points start close =
    if start.x > close.x then (close.x, close.y, start.x)
    else (start.x, start.y, close.x)

  let rec draw_line x y p two_dy two_dy_dx x_end modificator =
    if x > x_end then ()
    else begin
      Pixellib.set_pixel_exp x y 0;
      let (next_y, next_p) = get_next_possibility y p two_dy two_dy_dx modificator in
        draw_line (inc x) next_y next_p two_dy two_dy_dx x_end modificator
    end

  let line start close dx dy modificator =
    let p = 2 * dy - dx
    and two_dy = 2 * dy
    and two_dy_dx = 2 * (dy - dx)
    and (initial_x, initial_y, x_end) = get_initial_points start close in
      draw_line initial_x initial_y p two_dy two_dy_dx x_end modificator
end

module BigSlope = struct
  let get_initial_points start close =
    if start.y > close.y then (close.x, close.y, start.y)
    else (start.x, start.y, close.y)

  let rec draw_line x y p two_dy two_dy_dx y_end modificator =
    if y > y_end then ()
    else begin
      Pixellib.set_pixel_exp x y 0;
      let (next_x, next_p) = get_next_possibility x p two_dy two_dy_dx modificator in
      draw_line next_x (inc y) next_p two_dy two_dy_dx y_end modificator
    end

  let line start close dx dy modificator =
    let p = 2 * dx - dy
    and two_dx = 2 * dx
    and two_dy_dx = 2 * (dx - dy)
    and (initial_x, initial_y, y_end) = get_initial_points start close in
      draw_line initial_x initial_y p two_dx two_dy_dx y_end modificator
end

let get_modificator start close =
  let m = float_of_int (close.y - start.y)
          /. float_of_int (close.x - start.x) in
    if m < 0.0 then dec
    else inc

let line start close =
  let dx = abs (close.x - start.x)
  and dy = abs (close.y - start.y) in
  if (dx > dy)
  then LessSlope.line start close dx dy (get_modificator start close)
  else BigSlope.line start close dx dy (get_modificator start close)
