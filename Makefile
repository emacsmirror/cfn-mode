.PHONY = build deps lint clean defs FORCE

PACKAGES := cfn-mode flycheck-cfn

GENERATED := cfn-mode/cfn-resources.el cfn-mode/cfn-properties.el

build:
	$(foreach pkg, $(PACKAGES), $(MAKE) -C $(pkg) $@;)

deps:
	$(foreach pkg, $(PACKAGES), $(MAKE) -C $(pkg) $@;)

lint:
	$(foreach pkg, $(PACKAGES), $(MAKE) -C $(pkg) $@;)

clean:
	$(foreach pkg, $(PACKAGES), $(MAKE) -C $(pkg) $@;)

defs: $(GENERATED)

cfn-gen/%.el:
	$(MAKE) -C $(@D) $(@F)

cfn-mode/%.el: cfn-gen/%.el FORCE
	mv $< $@

FORCE:
