
PACKAGES := cfn-mode flycheck-cfn

GENERATED := cfn-mode/cfn-resources.dat cfn-mode/cfn-properties.dat

build:
	$(foreach pkg, $(PACKAGES), $(MAKE) -C $(pkg) $@;)

deps:
	$(foreach pkg, $(PACKAGES), $(MAKE) -C $(pkg) $@;)

lint:
	$(foreach pkg, $(PACKAGES), $(MAKE) -C $(pkg) $@;)

test:
	$(foreach pkg, $(PACKAGES), $(MAKE) -C $(pkg) $@;)

clean:
	$(foreach pkg, $(PACKAGES), $(MAKE) -C $(pkg) $@;)

defs: $(GENERATED)

cfn-gen/%.dat:
	$(MAKE) -C $(@D) $(@F)

cfn-mode/%.dat: cfn-gen/%.dat FORCE
	mv $< $@

FORCE:
.PHONY: build deps lint clean defs test FORCE
