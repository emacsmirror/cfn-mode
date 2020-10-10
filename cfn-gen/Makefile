include ../common.mk

EMACSFLAGS := -L ../cfn-mode
FILES := cfn-gen.elc

defs:
	$(CASK) exec $(EMACSBATCH) \
		$(EMACSFLAGS) \
		--eval "(require 'cfn-gen)" \
		-f cfn-gen-batch-all-defaults \
		$(patsubst %.elc,%.el,$(FILES))
