# Makefile for Indonesian-Malaysian MT

VERSION=0.1.1
LANG1=id
LANG2=ms
PREFIX1=$(LANG1)-$(LANG2)
PREFIX2=$(LANG2)-$(LANG1)

BASENAME=apertium-$(PREFIX1)

TARGETS_COMMON = $(PREFIX1).autobil.bin $(PREFIX2).autobil.bin \
	$(PREFIX1).automorf.bin $(PREFIX1).autogen.bin $(PREFIX1).t1x.bin \
	$(PREFIX2).automorf.bin $(PREFIX2).autogen.bin $(PREFIX2).t1x.bin

# This include defines goals for install-modes, .deps/.d and .mode files:
@ap_include@


###############################################################################
## Transducers, disambiguation rules, transfer
###############################################################################

# Indonesian transducer

$(PREFIX1).automorf.bin: $(BASENAME).$(LANG1).dix
	apertium-validate-dictionary $(BASENAME).$(LANG1).dix
	lt-comp lr $(BASENAME).$(LANG1).dix $@

$(PREFIX2).autogen.bin: $(BASENAME).$(LANG1).dix
	apertium-validate-dictionary $(BASENAME).$(LANG1).dix
	lt-comp rl $(BASENAME).$(LANG1).dix $@

# Malaysian transducer

$(PREFIX2).automorf.bin: $(BASENAME).$(LANG2).dix
	apertium-validate-dictionary $(BASENAME).$(LANG2).dix
	lt-comp lr $(BASENAME).$(LANG2).dix $@

$(PREFIX1).autogen.bin: $(BASENAME).$(LANG2).dix
	apertium-validate-dictionary $(BASENAME).$(LANG2).dix
	lt-comp rl $(BASENAME).$(LANG2).dix $@

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

$(PREFIX2).t1x.bin: $(BASENAME).$(PREFIX2).t1x
	apertium-validate-transfer $(BASENAME).$(PREFIX2).t1x
	apertium-preprocess-transfer $(BASENAME).$(PREFIX2).t1x $@

empty.bin: empty.t1x
	apertium-validate-transfer empty.t1x
	apertium-preprocess-transfer empty.t1x $@


###############################################################################
## Distribution
###############################################################################

EXTRA_DIST=$(PREFIX1).prob $(PREFIX2).prob \
           $(BASENAME).$(LANG1).dix \
           $(BASENAME).$(LANG2).dix \
           $(BASENAME).$(PREFIX1).dix \
           $(BASENAME).$(PREFIX1).t1x \
           $(BASENAME).$(PREFIX2).t1x \
           modes.xml

###############################################################################
## Installation
###############################################################################

apertium_id_msdir=$(prefix)/share/apertium/$(BASENAME)/

# Files which should be installed to $(prefix)/share/apertium/$(BASENAME)/:
apertium_id_ms_DATA=$(TARGETS_COMMON) \
                    $(PREFIX1).prob $(PREFIX2).prob \
		    $(BASENAME).$(PREFIX1).t1x $(BASENAME).$(PREFIX2).t1x


# All modes are created by the same goal, listing several will just give problems with make -j2
noinst_DATA=modes/$(PREFIX1).mode

install-data-local: install-modes


###############################################################################
## Cleanup
###############################################################################

CLEANFILES = $(TARGETS_COMMON)
clean-local: 
	-rm -rf .deps modes

###############################################################################
## Test
###############################################################################

test: all
	echo "TODO" | apertium -d . id-ms | tee .test-mt
	@echo "TODO" > .test-ref
	@diff .test-ref .test-mt
	echo "TODO" | apertium -d . ms-id | tee .test-mt
	@echo "TODO" > .test-ref
	@diff .test-ref .test-mt
	@rm .test-ref .test-mt
