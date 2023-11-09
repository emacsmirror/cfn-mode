;;; test-helper.el --- Helpers for cfn-mode-test.el

;;; Commentary:

;;; Code:

(defconst cfn-mode-test-file-prefix "cfn-mode-test-")

(defun with-temporary-file (fun contents)
  "Run FUN with a temporary file with CONTENTS.

FUN should take one argument, FIL with the name of the file."
  (let ((fil (make-temp-file cfn-mode-test-file-prefix
                             nil nil contents)))
    (condition-case err
        (funcall fun fil)
      (t (progn
           (delete-file fil)
           (error err)))
      (:success (delete-file fil)))))

;;; test-helper.el ends here
