;;; json-validate.el
;;
;; Helpers for sending jsons to a validator.
;; Requires: https://github.com/trentm/json

(defun json-validate-buffer ()
  "Validates the entire buffer for json."
  (interactive)
  (json-validate (buffer-substring (point-min) (point-max))))

(defun json-validate-region ()
  "Validates the entire buffer for json."
  (interactive)
  (json-validate (buffer-substring (mark) (point))))

(defun json-validate-string (json)
  "Validates a provided string of json."
  (interactive "sJson to validate: ")
  (json-validate json))

(defun json-display-string (json)
  "Displays a json as shell command output with formatting."
  (interactive "sJson to display (formatted): ")
  (json-display json))

(defun json-validate (json)
  (setq response (shell-command-to-string (format "echo '%s' | json --validate" json)))
  (if (= (length response) 0)
      (message "No errors found.")
    (message response)))

(defun json-display (json)
  (shell-command (format "echo '%s' | json %s" json)))

(provide 'json-validate)
;;; json-validate.el ends here
