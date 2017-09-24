open Pixellib

let get_initial_points start close =
  if start.x > close.x then (close.x, close.y, start.x)
  else (start.x, start.y, close.x)

let get_next_possibility y p two_dy two_dy_dx =
  if (p < 0) then (y, p + two_dy)
  else (y + 1, p + two_dy_dx)

let rec draw_line x y p two_dy two_dy_dx x_end =
  if x > x_end then ()
  else begin
    Pixellib.set_pixel_exp x y 0;
    let (next_y, next_p) = get_next_possibility y p two_dy two_dy_dx in
      draw_line (x + 1) next_y next_p two_dy two_dy_dx x_end
  end

let line start close =
  let dx = abs (close.x - start.x)
  and dy = abs (close.y - start.y) in
  let p = 2 * dy - dx
  and two_dy = 2 * dy
  and two_dy_dx = 2 * (dy - dx)
  and (initial_x, initial_y, x_end) = get_initial_points start close in
    draw_line initial_x initial_y p two_dy two_dy_dx x_end
