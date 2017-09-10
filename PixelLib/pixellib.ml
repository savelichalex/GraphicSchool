(* open Printf *)

external openDisplayBufferExp: unit -> unit = "open_display_buffer"
external setPixelExp: int -> int -> int -> unit = "set_pixel"


let rec drawLine line =
  match line with
  | [] -> ()
  | first :: rest ->
      let (x, y) = first in
        Printf.printf "%i, %i" x y;
        setPixelExp x y 0;
      drawLine rest
  ;;


let () =
  try
    openDisplayBufferExp ();
    drawLine [(5,5);(6,6);(7,7)]
  with
  | Failure (a) -> print_string a
