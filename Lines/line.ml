type point = { x: int; y: int }

let get_steps_count dx dy =
  if abs dx > abs dy then abs dx
  else abs dy

let round a =
  if (a -. floor a) > 0.5 then ceil a else a

let get_pixel_point a =
  a |> round |> truncate

let rec draw_line_DDA x y x_inc y_inc steps count =
  if count > steps then ()
  else begin
    Pixellib.set_pixel_exp
      (get_pixel_point x)
      (get_pixel_point y)
      0;
    draw_line_DDA
      (x +. x_inc)
      (y +. y_inc)
      x_inc y_inc steps (count + 1)
  end

let line_DDA ~start:start ~close:close =
  let dx = close.x - start.x
  and dy = close.y - start.y in
    let steps = get_steps_count dx dy in
      let x_increment = (float_of_int dx) /. (float_of_int steps)
      and y_increment = (float_of_int dy) /. (float_of_int steps) in
      draw_line_DDA
        (float_of_int start.x)
        (float_of_int start.y)
        x_increment y_increment steps 0

let () =
  Pixellib.open_display_buffer_exp ();
  line_DDA {x=50; y=50} {x=80;y=60}
