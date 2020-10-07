.PHONY = build

PACKAGES := cfn-mode flycheck-cfn

build:
	$(foreach pkg, $(PACKAGES), $(MAKE) -C $(pkg) $@;)

deps:
	$(foreach pkg, $(PACKAGES), $(MAKE) -C $(pkg) $@;)

lint:
	$(foreach pkg, $(PACKAGES), $(MAKE) -C $(pkg) $@;)

clean:
	$(foreach pkg, $(PACKAGES), $(MAKE) -C $(pkg) $@;)
