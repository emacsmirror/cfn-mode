;;; cfn-mode-test.el --- Tests for cfn-mode

;;; Commentary:

;;; Code:

(require 'cfn-mode)
(require 'ert)

(ert-deftest cfn-mode-test-fontlock-empty-file ()
  "Should raise an error when reading keywords from empty file."
  (let ((fil (make-temp-file cfn-mode-test-file-prefix)))
    (should-error (cfn--read-font-lock-keywords fil))
    (delete-file fil)))

(ert-deftest cfn-mode-test-fontlock-newline-file ()
  "Should not raise an error and parse values with newlines."
  (with-temporary-file (lambda (fil)
                         (should
                          (equal
                           (cfn--read-font-lock-keywords fil)
                           '(foo bar))))
                       "(foo\nbar)"))

(ert-deftest cfn-mode-test-fontlock-space-file ()
  "Should not raise an error and parse values with spaces."
  (with-temporary-file (lambda (fil)
                         (should
                          (equal
                           (cfn--read-font-lock-keywords fil)
                           '(foo bar))))
                       "(foo bar)"))

(ert-deftest cfn-mode-test-font-lock-keywords ()
  "Test sentinel values and that const isn't empty."
  (should (/= (length cfn-font-lock-keywords) 0))
  (should (member
           '("[\"']?\\(\\<AWS::EC2::Instance\\>\\)[\"']?" . 1)
           cfn-font-lock-keywords)))

;;; cfn-mode-test.el ends here
