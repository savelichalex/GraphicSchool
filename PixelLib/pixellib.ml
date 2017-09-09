external openDisplayBuffer: unit -> unit = "open_display_buffer"
external setPixel: int -> int -> int -> unit = "set_pixel"



let () =
   let o = openDisplayBuffer () in
     setPixel 2 2 0
