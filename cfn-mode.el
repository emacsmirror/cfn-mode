;;; cfn-mode.el --- AWS cloudformation mode -*- lexical-binding: t; -*-

;; Copyright (C) 2020  William Orr <will@worrbase.com>
;;
;; Author: William Orr <will@worrbase.com>
;; Version: 0.1.0
;; Keywords: convenience languages tools
;; Package-Requires: ((emacs "25.3"))
;; URL: https://gitlab.com/worr/cfn-mode

;; cfn-mode is free software; you can redistribute it and/or modify it
;; under the terms of the GNU General Public License as published by the Free
;; Software Foundation; either version 3, or (at your option) any later version.
;;
;; cfn-mode is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
;; FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
;; details.
;;
;; You should have received a copy of the GNU General Public License
;; along with cfn-mode.  If not, see http://www.gnu.org/licenses.

;;; Commentary:

;; This package adds a mode for AWS Cloudformation

;;; Code:

(require 'mmm-mode)
(require 'yaml-mode)
(require 'mmm-jinja2)

(define-derived-mode cfn-mode yaml-mode
  "AWS Cloudformation

Cloudformation mode derived from yaml-mode.")

(defun cfn-mode-setup-jinja ()
  "Set up jinja support for sceptre yaml.

`cfn-mode' can optionally use jinja2 to support templated cfn files, as used
in sceptre."
  (mmm-add-mode-ext-class 'cfn-mode "\\.j2\'" 'jinja2))

;; Detect cfn yaml files based on ~AWSTemplateFormatVersion~ property
;;;###autoload
(add-to-list 'magic-mode-alist
             '("\\(---\n\\)?AWSTemplateFormatVersion:" . cfn-mode))

;; This is to support sceptre, which supports both standard
;; cfn yaml files as well as yaml files templated with jinja
;;;###autoload
(add-to-list 'auto-mode-alist
             '("\\.yaml.j2\\'" . cfn-mode))

(add-hook 'cfn-mode-hook 'mmm-mode)
(add-hook 'mmm-mode-hook 'cfn-mode-setup-jinja)

(provide 'cfn-mode)

;;; cfn-mode.el ends here
