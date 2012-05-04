# Makefile for Indonesian-Malaysian MT

VERSION=0.1.0
LANG1=id
LANG2=ms
PREFIX1=$(LANG1)-$(LANG2)
PREFIX2=$(LANG2)-$(LANG1)

BASENAME=apertium-$(PREFIX1)

TARGETS_COMMON = $(PREFIX1).autobil.bin \
	$(PREFIX1).automorf.bin $(PREFIX1).autogen.bin $(PREFIX1).t1x.bin \
	$(PREFIX2).automorf.bin $(PREFIX2).autogen.bin \
	$(PREFIX1).mode modes

# Indonesian transducer
	
.deps/$(LANG1).dix:
	if [ ! -d .deps ]; then mkdir .deps; fi
	xsltproc buscaPar.xsl $(BASENAME).$(LANG1).metadix | uniq >$$$$tmp1 && \
	xsltproc $$$$tmp1 $(BASENAME).$(LANG1).metadix > $@ && rm $$$$tmp1
	
$(PREFIX1).automorf.bin: .deps/$(LANG1).dix
	apertium-validate-dictionary .deps/$(LANG1).dix
	lt-comp lr .deps/$(LANG1).dix $@

$(PREFIX2).autogen.bin: .deps/$(LANG1).dix
	apertium-validate-dictionary .deps/$(LANG1).dix
	lt-comp rl .deps/$(LANG1).dix $@

# Malaysian transducer

.deps/$(LANG2).dix:
	if [ ! -d .deps ]; then mkdir .deps; fi
	xsltproc buscaPar.xsl $(BASENAME).$(LANG2).metadix | uniq >$$$$tmp1 && \
	xsltproc $$$$tmp1 $(BASENAME).$(LANG2).metadix > $@ && rm $$$$tmp1

$(PREFIX2).automorf.bin: .deps/$(LANG2).dix
	apertium-validate-dictionary .deps/$(LANG2).dix
	lt-comp lr .deps/$(LANG2).dix $@

$(PREFIX1).autogen.bin: .deps/$(LANG2).dix
	apertium-validate-dictionary .deps/$(LANG2).dix
	lt-comp rl .deps/$(LANG2).dix $@
	
# Bilingual dictionaries

$(PREFIX1).autobil.bin: $(BASENAME).$(PREFIX1).dix
	apertium-validate-dictionary $<
	lt-comp lr $< $@

$(PREFIX2).autobil.bin: $(BASENAME).$(PREFIX1).dix
	apertium-validate-dictionary $< 
	lt-comp rl $< $@
	
# Transfer rules

$(PREFIX1).t1x.bin: $(BASENAME).$(PREFIX1).t1x
	apertium-validate-transfer $(BASENAME).$(PREFIX1).t1x
	apertium-preprocess-transfer $(BASENAME).$(PREFIX1).t1x $@
	
empty.bin: empty.t1x
	apertium-validate-transfer empty.t1x
	apertium-preprocess-transfer empty.t1x $@
	
# Modes

modes/$(PREFIX1).mode: modes.xml
	apertium-validate-modes modes.xml
	apertium-gen-modes modes.xml
	cp *.mode modes/
	
# Installation

EXTRA_DIST=$(PREFIX1).prob \
           $(BASENAME).$(PREFIX1).t1x \
           modes.xml
           
apertium_id_msmodesdir=$(prefix)/share/apertium/modes/
apertium_id_msdir=$(prefix)/share/apertium/$(BASENAME)/

apertium_id_ms_DATA=$(PREFIX1).autobil.bin \
                    $(PREFIX1).prob \
		    $(PREFIX1).autogen.bin $(PREFIX2).autogen.bin \
		    $(PREFIX1).automorf.bin $(PREFIX2).automorf.bin \
		    $(PREFIX1).t1x.bin \
		    $(BASENAME).$(PREFIX1).t1x \
		    modes.xml

noinst_DATA=modes/$(PREFIX1).mode

install-data-local:
	mv modes modes~
	$(prefix)/bin/apertium-gen-modes modes.xml $(BASENAME)
	rm -rf modes
	mv modes~ modes
	test -d $(DESTDIR)$(apertium_id_msmodesdir) || mkdir $(DESTDIR)$(apertium_id_msmodesdir)
	$(INSTALL_DATA) $(PREFIX1).mode $(DESTDIR)$(apertium_id_msmodesdir)
	rm $(PREFIX1).mode
	$(INSTALL_DATA) $(BASENAME).$(PREFIX1).t1x $(DESTDIR)$(apertium_id_msdir)

CLEANFILES = -r $(TARGETS_COMMON) .deps/