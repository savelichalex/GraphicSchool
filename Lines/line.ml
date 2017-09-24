open Pixellib

let run_test_case line_draw start close =
  line_draw start close

let () =
  open_display_buffer_exp ();
  (* Draw lines, it's like a test case for line drawing *)
  let line_draw = run_test_case Brezenham.line in
    line_draw {x=50; y=50} {x=75;y=75};
    line_draw {x=50; y=50} {x=25;y=25};
    line_draw {x=50; y=50} {x=75;y=25};
    line_draw {x=50; y=50} {x=25;y=75};
    line_draw {x=50; y=50} {x=80;y=50};
    line_draw {x=50; y=50} {x=20;y=50};
    line_draw {x=50; y=50} {x=50;y=80};
    line_draw {x=50; y=50} {x=50;y=20};
    line_draw {x=50; y=50} {x=80;y=60};
    line_draw {x=50; y=50} {x=20;y=40};
    line_draw {x=50; y=50} {x=80;y=40};
    line_draw {x=50; y=50} {x=20;y=60};
    line_draw {x=50; y=50} {x=60;y=80};
    line_draw {x=50; y=50} {x=40;y=20};
    line_draw {x=50; y=50} {x=40;y=80};
    line_draw {x=50; y=50} {x=60;y=20};
  (* Brezenham.line {x=1;y=1} {x=10;y=5} *)
