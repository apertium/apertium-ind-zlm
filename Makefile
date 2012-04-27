all: id-ms.automorf.hfst.ol ms-id.autogen.hfst.ol ms-id.automorf.hfst.ol id-ms.autogen.hfst.ol
	lt-comp lr apertium-id-ms.id-ms.dix id-ms.autobil.bin
	lt-comp rl apertium-id-ms.id-ms.dix ms-id.autobil.bin
	apertium-preprocess-transfer apertium-id-ms.id-ms.t1x id-ms.t1x.bin

id-ms.automorf.hfst.ol: xfst-id.bin
	gzcat xfst-id.bin | hfst-invert | hfst-fst2fst -O -o id-ms.automorf.hfst.ol

ms-id.autogen.hfst.ol: xfst-id.bin
	gzcat xfst-id.bin | hfst-fst2fst -O -o ms-id.autogen.hfst.ol

ms-id.automorf.hfst.ol: xfst-ms.bin
	gzcat xfst-ms.bin | hfst-invert | hfst-fst2fst -O -o ms-id.automorf.hfst.ol

id-ms.autogen.hfst.ol: xfst-ms.bin
	gzcat xfst-ms.bin | hfst-fst2fst -O -o id-ms.autogen.hfst.ol

xfst-id.bin:
	foma -l main-id.foma

xfst-ms.bin:
	foma -l main-ms.foma

clean:
	rm -f *.bin *.ol

test:
	cat ../dev/story.id.txt | hfst-proc id-ms.automorf.hfst.ol | apertium-tagger -g id-ms.prob | apertium-pretransfer | apertium-transfer apertium-id-ms.id-ms.t1x id-ms.t1x.bin id-ms.autobil.bin | hfst-proc -g id-ms.autogen.hfst.ol
