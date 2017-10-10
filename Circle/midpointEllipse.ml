open Pixellib

type desicion_parameter_const = {
  rx2: int;
  ry2: int;
  two_rx2: int;
  two_ry2: int
  }

let round a =
  if (a -. floor a) > 0.5 then ceil a else a

let draw_ellipse_points x_center y_center x y =
  Pixellib.set_pixel_exp (x_center + x) (y_center + y) 0;
  Pixellib.set_pixel_exp (x_center - x) (y_center + y) 0;
  Pixellib.set_pixel_exp (x_center + x) (y_center - y) 0;
  Pixellib.set_pixel_exp (x_center - x) (y_center - y) 0

module FirstRegion = struct
  let get_initial_desicion_parameter {rx2; ry2} {x=rx; y=ry} =
    round (float_of_int (ry2 - (rx2 * ry)) +. (0.25 *. (float_of_int rx2))) |> truncate

  let get_next_params x y px py p params =
    let nx = x + 1
    and npx = px + params.two_ry2 in
    if (p < 0) then (nx, y, npx, py, (p + params.ry2 + npx))
    else let npy = py - params.two_rx2 in
         (nx, (y - 1), npx, npy, (p + params.ry2 + npx - npy))

  let rec _draw x y px py p params center =
    if (px >= py) then (x, y, px, py)
    else begin
        draw_ellipse_points center.x center.y x y;
        let (nx, ny, npx, npy, np) = get_next_params x y px py p params in
        _draw nx ny npx npy np params center
      end

  let draw x y px py params center radius =
    _draw x y px py (get_initial_desicion_parameter params radius) params center
end

module SecondRegion = struct
  let get_initial_desicion_parameter {rx2; ry2} x y =
    round
      ((float_of_int ry2) *. ((float_of_int x) +. 0.5) *. ((float_of_int x) +. 0.5)
       +. (float_of_int (rx2 * (y - 1) * (y - 1) - (rx2 * ry2))))
    |> truncate

  let get_next_params x y px py p params =
    let ny = y - 1
    and npy = py - params.two_rx2 in
    if (p > 0) then (x, ny, px, npy, (p + params.rx2 - npy))
    else let npx = px + params.two_ry2 in
         ((x + 1), ny, npx, npy, (p + params.rx2 + npx - npy))

  let rec _draw x y px py p params center =
    if (y < 0) then ()
    else begin
        draw_ellipse_points center.x center.y x y;
        let (nx, ny, npx, npy, np) = get_next_params x y px py p params in
        _draw nx ny npx npy np params center
      end

  let draw x y px py params center radius =
    _draw x y px py (get_initial_desicion_parameter params x y) params center
end

let ellipse center radius =
  let rx2 = radius.x * radius.x
  and ry2 = radius.y * radius.y in
  let two_rx2 = 2 * rx2
  and two_ry2 = 2 * ry2 in
  let params = {rx2; ry2; two_rx2; two_ry2} in
  let (x, y, px, py) = FirstRegion.draw
    0 radius.y
    0 (two_rx2 * radius.y)
    params center radius in
  SecondRegion.draw x y px py params center radius

(*
  Interesting question:
  As i understand this algoritm, we divide ellipse quadrant in two
  parts and then draw like this is two circles with different radius.
  Am I right?
*)
let () =
  Pixellib.open_display_buffer_exp ();
  ellipse {x=50;y=50} {x=10;y=5};
  ellipse {x=50;y=50} {x=20;y=10};
  ellipse {x=50;y=50} {x=30;y=15};
  ellipse {x=50;y=50} {x=15;y=30}
