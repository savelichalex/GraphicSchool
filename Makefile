BUILD_DIR = build

.PHONY: clean

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

circle: pixellib.cmx pixellib_stubs.o midpointCircle.cmx
	ocamlopt -o circle.opt -I Pixellib/ -I Circle/ pixellib.cmx pixellib_stubs.o midpointCircle.cmx

clean:
	find . \( -name "*.o" -o -name "*.cmi" -o -name "*.cmx" \) -type f -delete && rm *.{o,opt}
