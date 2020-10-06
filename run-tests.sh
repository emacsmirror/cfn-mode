#!/bin/sh -e

# Taken generously from https://github.com/purcell/package-lint with my
# own modifications

EMACS="${EMACS:=emacs}"

NEEDED_PACKAGES="elisp-lint"

INIT_PACKAGE_EL="(progn \
  (require 'package) \
  (push '(\"melpa\" . \"https://melpa.org/packages/\") package-archives) \
  (package-initialize) \
  (unless package-archive-contents \
     (package-refresh-contents)) \
  (dolist (pkg '(${NEEDED_PACKAGES})) \
    (unless (package-installed-p pkg) \
      (package-install pkg))))"

"$EMACS" -Q -batch \
         --eval "$INIT_PACKAGE_EL" \
         --eval "(require 'elisp-lint)" \
         -f elisp-lint-files-batch \
         cfn-mode.el
