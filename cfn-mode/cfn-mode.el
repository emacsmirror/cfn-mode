;;; cfn-mode.el --- AWS cloudformation mode -*- lexical-binding: t; -*-

;; Copyright (C) 2020  William Orr <will@worrbase.com>
;;
;; Author: William Orr <will@worrbase.com>
;; Version: 0.1.0
;; Keywords: convenience languages tools
;; Package-Requires: ((emacs "26.0"))
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

(require 'yaml-mode)

(defgroup cfn nil
  "Cloudformation major mode."
  :group 'languages
  :prefix "cfn-"
  :link '(url-link :tag "Gitlab" "https://gitlab.com/worr/cfn-mode"))

;;;###autoload
(define-derived-mode cfn-mode yaml-mode
  "AWS Cloudformation"
  "Cloudformation mode derived from yaml-mode.")

;; Detect cfn yaml files based on ~AWSTemplateFormatVersion~ property
;;;###autoload
(add-to-list 'magic-mode-alist
             '("\\(---\n\\)?AWSTemplateFormatVersion:" . cfn-mode))

(provide 'cfn-mode)

;;; cfn-mode.el ends here
