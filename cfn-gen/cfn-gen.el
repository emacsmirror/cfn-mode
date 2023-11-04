;;; cfn-gen.el --- CFN definition fetcher and parser -*- lexical-binding: t; -*-

;; Copyright (C) 2020  William Orr <will@worrbase.com>
;;
;; Author: William Orr <will@worrbase.com>
;; Version: 1.0.2
;; Keywords: convenience
;; Package-Requires: ((emacs "27.1") (f "0.20.0") (request "0.3.2") (s "1.12.0"))
;; URL: https://gitlab.com/worr/cfn-mode

;; cfn-gen is free software; you can redistribute it and/or modify it
;; under the terms of the GNU General Public License as published by the Free
;; Software Foundation; either version 3, or (at your option) any later version.
;;
;; cfn-gen is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
;; FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
;; details.
;;
;; You should have received a copy of the GNU General Public License
;; along with cfn-gen.  If not, see http://www.gnu.org/licenses.

;;; Commentary:

;; This package downloads Cloudformation type definitions from AWS for use
;; with other Emacs packages.  You do not need to run or install this yourself.
;;

;;; Code:
(require 'cl-lib)
(require 'f)
(require 'request)
(require 's)

(defconst cfn-gen-regional-cfn-urls
  '((us-east-2 . "https://dnwj8swjjbsbt.cloudfront.net/latest/gzip/CloudFormationResourceSpecification.json")
    (us-east-1 . "https://d1uauaxba7bl26.cloudfront.net/latest/gzip/CloudFormationResourceSpecification.json")
    (us-west-1 . "https://d68hl49wbnanq.cloudfront.net/latest/gzip/CloudFormationResourceSpecification.json")
    (us-west-2 . "https://d201a2mn26r7lk.cloudfront.net/latest/gzip/CloudFormationResourceSpecification.json")
    (af-south-1 . "https://cfn-resource-specifications-af-south-1-prod.s3.af-south-1.amazonaws.com/latest/gzip/CloudFormationResourceSpecification.json")
    (ap-east-1 . "https://cfn-resource-specifications-ap-east-1-prod.s3.ap-east-1.amazonaws.com/latest/gzip/CloudFormationResourceSpecification.json")
    (ap-south-1 . "https://d2senuesg1djtx.cloudfront.net/latest/gzip/CloudFormationResourceSpecification.json")
    (ap-northeast-3 . "https://d2zq80gdmjim8k.cloudfront.net/latest/gzip/CloudFormationResourceSpecification.json")
    (ap-northeast-2 . "https://d1ane3fvebulky.cloudfront.net/latest/gzip/CloudFormationResourceSpecification.json")
    (ap-southeast-1 . "https://doigdx0kgq9el.cloudfront.net/latest/gzip/CloudFormationResourceSpecification.json")
    (ap-southeast-2 . "https://d2stg8d246z9di.cloudfront.net/latest/gzip/CloudFormationResourceSpecification.json")
    (ap-northeast-1 . "https://d33vqc0rt9ld30.cloudfront.net/latest/gzip/CloudFormationResourceSpecification.json")
    (ca-central-1 . "https://d2s8ygphhesbe7.cloudfront.net/latest/gzip/CloudFormationResourceSpecification.json")
    (cn-north-1 . "https://cfn-resource-specifications-cn-north-1-prod.s3.cn-north-1.amazonaws.com.cn/latest/gzip/CloudFormationResourceSpecification.json")
    (cn-northwest-1 . "https://cfn-resource-specifications-cn-northwest-1-prod.s3.cn-northwest-1.amazonaws.com.cn/latest/gzip/CloudFormationResourceSpecification.json")
    (eu-central-1 . "https://d1mta8qj7i28i2.cloudfront.net/latest/gzip/CloudFormationResourceSpecification.json")
    (eu-west-1 . "https://d3teyb21fexa9r.cloudfront.net/latest/gzip/CloudFormationResourceSpecification.json")
    (eu-west-2 . "https://d1742qcu2c1ncx.cloudfront.net/latest/gzip/CloudFormationResourceSpecification.json")
    (eu-west-3 . "https://d2d0mfegowb3wk.cloudfront.net/latest/gzip/CloudFormationResourceSpecification.json")
    (eu-north-1 . "https://diy8iv58sj6ba.cloudfront.net/latest/gzip/CloudFormationResourceSpecification.json")
    (eu-south-1 . "https://cfn-resource-specifications-eu-south-1-prod.s3.eu-south-1.amazonaws.com/latest/gzip/CloudFormationResourceSpecification.json")
    (me-south-1 . "https://cfn-resource-specifications-me-south-1-prod.s3.me-south-1.amazonaws.com/latest/gzip/CloudFormationResourceSpecification.json")
    (sa-east-1 . "https://d3c9jyj3w509b0.cloudfront.net/latest/gzip/CloudFormationResourceSpecification.json"))
  "Region to CFN definition URI mapping.")

(defvar cfn-gen-dump (make-hash-table)
  "Dumping ground for consumed definitions.")

(defun cfn-gen-dump-results (region results)
  "Write each REGION's RESULTS to a variable."
  (message "%s" (symbol-name region))
  (puthash (symbol-name region) results cfn-gen-dump))

(defun cfn-gen-fetch-definitions (region url)
  "Fetches CFN definitions for a single REGION from URL."
  (request
    url
    :headers '((Content-Type . "application-json"))
    :parser #'json-parse-buffer
    :sync t
    :success
    (cl-function
     (lambda (&key data &allow-other-keys)
       (cfn-gen-dump-results region data)))
    :error
    (cl-function
     (lambda (&rest args &key error-thrown &allow-other-keys)
       (message "Got error %S" error-thrown)))))

(defun cfn-gen-fetch-all-definitions ()
  "Fetch all definitions and dump them into a variable."
  (dolist (element cfn-gen-regional-cfn-urls)
    (cfn-gen-fetch-definitions (car element) (cdr element))))

;; (cfn-gen-fetch-definitions
;;   'eu-west-1 (alist-get 'eu-west-1 cfn-gen-regional-cfn-urls))

(defun cfn-gen-write-definitions-file (filename)
  "Write the fetched definitions into FILENAME."
  (unless (stringp filename)
    (error "Filename must be string"))
  (f-write-text
   (json-serialize cfn-gen-dump)
   coding-category-utf-8
   filename))

(defun cfn-gen-deep-get (key data)
  "Gets per-entity KEY from hash-table DATA from Amazon."
  (unless (hash-table-p data)
    (error "DATA must be hash table"))
  (unless (stringp key)
    (error "KEY must be a string"))
  (sort
   (delete-dups
    (let (result)
      (dolist (element (hash-table-values data) result)
        (setq result (append (hash-table-keys (gethash key element)) result)))))
   #'string<))

(defun cfn-gen-get-types (data)
  "Gets all CFN types from hash-table DATA."
  (cfn-gen-deep-get "ResourceTypes" data))

(defun cfn-gen-get-properties (data)
  "Gets all CFN properties from hash-table DATA."
  (sort
   (delete-dups
    (let (result)
      (dolist (element (cfn-gen-deep-get "PropertyTypes" data) result)
        (setq result (append (list (car (split-string element "\\."))) result)))))
   #'string<))

(defun cfn-gen-serialize-to-file (object filename)
  "Write elisp OBJECT to FILENAME."
  (f-write-text
   (s-replace-all '((" " . "\n "))
                  (prin1-to-string object))
   coding-category-utf-8
   filename))

(defun cfn-gen-write-resource-file (filename)
  "Write all of the resources into FILENAME."
  (cfn-gen-serialize-to-file
   (if-let ((cfn-gen-resources (cfn-gen-get-types cfn-gen-dump)))
       cfn-gen-resources
     (error "Got 0 resources from AWS; aborting."))
   filename))

(defun cfn-gen-write-properties-file (filename)
  "Write all of the properties into FILENAME."
  (cfn-gen-serialize-to-file
   (if-let ((cfn-gen-properties (cfn-gen-get-properties cfn-gen-dump)))
       cfn-gen-properties
     (error "Got 0 properties from AWS; aborting."))
   filename))

(defun cfn-gen-batch-all-defaults ()
  "Fetch all definitions and write them out to default locations."
  (cfn-gen-fetch-all-definitions)
  (cfn-gen-write-definitions-file "cfn-all.json")
  (cfn-gen-write-resource-file "cfn-resources.dat")
  (cfn-gen-write-properties-file "cfn-properties.dat"))

(provide 'cfn-gen)

;;; cfn-gen.el ends here
