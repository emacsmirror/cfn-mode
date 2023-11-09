include ../common.mk

EMACSFLAGS := -L ../cfn-mode
FILES := cfn-gen.elc test/cfn-gen-test.elc test/test-helper.elc

cfn-resources.dat cfn-properties.dat: cfn-gen.elc
	$(CASK) exec $(EMACSBATCH) \
		$(EMACSFLAGS) \
		--eval "(require 'cfn-gen)" \
		-f cfn-gen-batch-all-defaults \
		$(patsubst %.elc,%.el,$(FILES))
