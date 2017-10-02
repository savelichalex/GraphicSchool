open Pixellib

(* Draw points in all octants *)
let draw_circle_points x_center y_center x y =
  Pixellib.set_pixel_exp (x_center + x) (y_center + y) 0;
  Pixellib.set_pixel_exp (x_center - x) (y_center + y) 0;
  Pixellib.set_pixel_exp (x_center + x) (y_center - y) 0;
  Pixellib.set_pixel_exp (x_center - x) (y_center - y) 0;
  Pixellib.set_pixel_exp (x_center + y) (y_center + x) 0;
  Pixellib.set_pixel_exp (x_center - y) (y_center + x) 0;
  Pixellib.set_pixel_exp (x_center + y) (y_center - x) 0;
  Pixellib.set_pixel_exp (x_center - y) (y_center - x) 0

let get_params x y p =
  if (p < 0) then (x, y, p + (2 * x) + 1)
  else (x, y - 1, p + 2 * (x - (y - 1)) + 1)

let rec draw_circle x y p x_center y_center =
  if (x > y) then ()
  else begin
      draw_circle_points x_center y_center x y;
      let (next_x, next_y, next_p) = get_params (x + 1) y p in
      draw_circle next_x next_y next_p x_center y_center
    end

let circle center radius =
  let p = 1 - radius in
  draw_circle 0 radius p center.x center.y

let () =
  Pixellib.open_display_buffer_exp ();
  circle {x=50;y=50} 10;
  circle {x=50;y=50} 20;
  circle {x=50;y=50} 30;
  circle {x=50;y=50} 40;
  circle {x=50;y=50} 50;
