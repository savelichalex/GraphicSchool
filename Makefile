BUILD_DIR = build

.PHONY: clean

pixellib.cmx:
	ocamlopt -c Pixellib/pixellib.ml -I Pixellib/ -bin-annot

pixellib_stubs.o:
	ocamlopt -c Pixellib/pixellib_stubs.c -I Pixellib/

line.cmx:
	ocamlopt -c Lines/line.ml -I Lines/ -I Pixellib/ -bin-annot

line: pixellib.cmx pixellib_stubs.o line.cmx
	ocamlopt -o lines.opt -I Pixellib/ -I Lines/ pixellib.cmx pixellib_stubs.o line.cmx

clean:
	find . \( -name "*.o" -o -name "*.cmi" -o -name "*.cmx" \) -type f -delete && rm *.o
