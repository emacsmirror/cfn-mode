.PHONY = deps build lint clean

FILES := cfn-mode.elc

CASK ?= cask
EMACS ?= emacs

.el.elc:
	$(CASK) build

deps:
	$(CASK) install

build: $(FILES)

lint: $(FILES)
	$(CASK) exec $(EMACS) \
		-Q \
		-batch \
		--eval "(require 'elisp-lint)" \
		-f elisp-lint-files-batch \
		$(patsubst %.elc,%.el,$(FILES))

clean:
	cask clean-elc
	rm -f *-autoloads.el *-autoloads.el~
