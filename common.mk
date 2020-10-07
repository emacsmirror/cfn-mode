.PHONY = deps build lint clean

CASK ?= cask
EMACS ?= emacs
EMACSBATCH = $(EMACS) -Q -batch
EMACSFLAGS ?=

.el.elc:
	$(CASK) build

deps:
	$(CASK) install

build: $(FILES)

lint: $(FILES)
	$(CASK) exec $(EMACSBATCH) \
		$(EMACSFLAGS) \
		--eval "(require 'elisp-lint)" \
		-f elisp-lint-files-batch \
		$(patsubst %.elc,%.el,$(FILES))

clean:
	cask clean-elc
	rm -f *-autoloads.el *-autoloads.el~
