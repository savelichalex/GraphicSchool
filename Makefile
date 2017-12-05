BUILD_DIR = build

.PHONY: clean

PIXELLIBOBJ = pixellib.cmx pixellib_stubs.o

pixellib.cmx: Pixellib/pixellib.ml
	ocamlopt -c $< -I Pixellib/ -bin-annot

pixellib_stubs.o: Pixellib/pixellib_stubs.c
	ocamlopt -c $< -I Pixellib/

dda.cmx:Lines/dda.ml
	ocamlopt -c $< -I Lines/ -I Pixellib/ -bin-annot

brezenham.cmx: Lines/brezenham.ml
	ocamlopt -c $< -I Lines/ -I Pixellib/ -bin-annot

line.cmx: Lines/line.ml
	ocamlopt -c $< -I Lines/ -I Pixellib/ -bin-annot

line: pixellib.cmx pixellib_stubs.o dda.cmx brezenham.cmx line.cmx
	ocamlopt -o lines.opt -I Pixellib/ -I Lines/ pixellib.cmx pixellib_stubs.o dda.cmx brezenham.cmx line.cmx

midpointCircle.cmx: Circle/midpointCircle.ml
	ocamlopt -c $< -I Circle/ -I Pixellib/ -bin-annot

circle: $(PIXELLIBOBJ) midpointCircle.cmx
	ocamlopt -o circle.opt -I Pixellib/ -I Circle/ $^

midpointEllipse.cmx: Circle/midpointEllipse.ml
	ocamlopt -c $< -I Circle/ -I Pixellib/ -bin-annot

ellipse: $(PIXELLIBOBJ) midpointEllipse.cmx
	ocamlopt -o $@ -I Pixellib/ -I Circle/ $^

bezier.cmx: Curves/bezier.ml
	ocamlopt -c $< -I Curves/ -I Pixellib/ -I Lines/ -bin-annot

bezier: $(PIXELLIBOBJ) brezenham.cmx bezier.cmx
	ocamlopt -o $@ -I Pixellib/ -I Lines/ -I Curves/ $^

clean:
	find . \( -name "*.o" -o -name "*.cmi" -o -name "*.cmx" \) -type f -delete && rm *.{o,opt}
