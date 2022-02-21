;;; cfn-mode.el --- AWS cloudformation mode -*- lexical-binding: t; -*-

;; Copyright (C) 2020  William Orr <will@worrbase.com>
;;
;; Author: William Orr <will@worrbase.com>
;; Version: 1.0.3
;; Keywords: convenience languages tools
;; Package-Requires: ((emacs "26.0") (f "0.20.0") (s "1.12.0")  (yaml-mode "0.0.13"))
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

;; cl-extra is part of emacs
(require 'cl-extra)

(require 'f)
(require 's)
(require 'yaml-mode)

(defgroup cfn nil
  "Cloudformation major mode."
  :group 'languages
  :prefix "cfn-"
  :link '(url-link :tag "Gitlab" "https://gitlab.com/worr/cfn-mode"))

(defun cfn--read-font-lock-keywords (filename)
  "Read font lock keywords from FILENAME."
  (read
   (split-string
    (f-read
     (f-join
      (f-dirname
       (or load-file-name (buffer-file-name)))
      filename)) "\n")))

(defconst cfn-font-lock-keywords
  (let ((properties (cfn--read-font-lock-keywords "cfn-properties.dat"))
        (resources (cfn--read-font-lock-keywords "cfn-resources.dat")))
    (cl-map #'list
            (lambda (item)
              (cons (s-wrap item "[\"']?\\(\\<" "\\>\\)[\"']?") 1))
            (append properties resources)))
  "Highlighted CFN keywords.")

;;;###autoload
(define-derived-mode cfn-mode yaml-mode
  "AWS Cloudformation"
  "Cloudformation mode derived from `yaml-mode'."
  (font-lock-add-keywords nil cfn-font-lock-keywords))

;; Detect cfn yaml files based on ~AWSTemplateFormatVersion~ property
;;;###autoload
(add-to-list 'magic-mode-alist
             '("\\(---\n\\)?AWSTemplateFormatVersion:" . cfn-mode))

(provide 'cfn-mode)

;;; cfn-mode.el ends here
