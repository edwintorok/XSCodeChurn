.PHONY: clean
target=diagram.png
all: clean $(target) 
%.png: %.dot
	dot -Tpng -o$@ $<
clean:
	rm -f $(target)

