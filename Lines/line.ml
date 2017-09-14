type point = { x: int; y: int }

let get_steps_count dx dy =
  if abs dx > abs dy then abs dx
  else abs dy

let get_pixel_point a b =
  float_of_int a +. b |> floor |> truncate

let rec draw_line_DDA x y x_inc y_inc steps count =
  if count > steps then ()
  else begin
    Pixellib.set_pixel_exp x y 0;
    draw_line_DDA
      (get_pixel_point x x_inc)
      (get_pixel_point y y_inc)
      x_inc y_inc steps (count + 1)
  end

let line_DDA ~start:start ~close:close =
  let dx = close.x - start.x
  and dy = close.y - start.y in
    let steps = get_steps_count dx dy in
      let x_increment = (float_of_int dx) /. (float_of_int steps)
      and y_increment = (float_of_int dy) /. (float_of_int steps) in
        draw_line_DDA start.x start.y x_increment y_increment steps 0

let () =
  Pixellib.open_display_buffer_exp ();
  line_DDA {x=1; y=1} {x=10;y=5}
