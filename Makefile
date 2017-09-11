PIXELLIB_SRC = PixelLib/pixellib.ml PixelLib/pixellib_stubs.c
PIXELLIB = pixellib.opt

BUILD_DIR = build

.PHONY: clean

$(PIXELLIB):
	ocamlopt -o $(PIXELLIB) $(PIXELLIB_SRC)

clean:
	find . \( -name "*.o" -o -name "*.cmi" -o -name "*.cmx" \) -type f -delete && rm $(PIXELLIB)
