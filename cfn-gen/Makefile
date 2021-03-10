include ../common.mk

.PHONY = defs

EMACSFLAGS := -L ../cfn-mode
FILES := cfn-gen.elc

cfn-resources.dat cfn-properties.dat: cfn-gen.elc
	$(CASK) exec $(EMACSBATCH) \
		$(EMACSFLAGS) \
		--eval "(require 'cfn-gen)" \
		-f cfn-gen-batch-all-defaults \
		$(patsubst %.elc,%.el,$(FILES))
