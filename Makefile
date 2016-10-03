default: symbols footprints

symbols symbols/*.sym: ESP8266.lib
	rm -rf symbols.was Converted
	-mv -f symbols symbols.was
	mkdir Converted
	kicad_symbol_to_geda < $<
	mv Converted/ symbols/

footprints/%.fp: ESP8266.pretty/%.kicad_mod
	mkdir -p footprints
	rm -rf Converted
	mkdir Converted # The -d option to the tool doesn't work, this is the workaround.
	kicad_module_to_geda < $^ # the -k option to the tool doesn't work, this is the workaround
	mv Converted/*.fp footprints/
	rm -rf Converted

MODULES=$(wildcard ESP8266.pretty/*.kicad_mod)
FOOTPRINTS=$(subst ESP8266.pretty,footprints,$(MODULES:.kicad_mod=.fp))

footprints: $(FOOTPRINTS)

clean:
	rm -rf symbols footprints

.PHONY: default symbols footprints
