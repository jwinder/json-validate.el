;;; json-validate.el
;;
;; Helpers for sending jsons to a validator.
;; Requires: https://github.com/trentm/json

(defcustom json-validate-display-buffer-name "*Json*"
  "Name of json response buffer.")

(defun json-validate-buffer ()
  "Validates the buffer of json."
  (interactive)
  (json-validate-for-errors (buffer-substring (point-min) (point-max))))

(defun json-validate-region ()
  "Validates a region of json."
  (interactive)
  (json-validate-for-errors (buffer-substring (mark) (point))))

(defun json-validate-string (json)
  "Validates a provided string of json."
  (interactive "sJson to validate: ")
  (json-validate-for-errors json))

(defun json-format-buffer ()
  "Formats a buffer of json."
  (interactive)
  (setq json (buffer-substring (point-min) (point-max)))
  (setq response (json-reformat json))
  (json-insert-in-current-buffer response (point-min) (point-max)))

(defun json-format-region ()
  "Formats a region of json."
  (interactive)
  (setq json (buffer-substring (mark) (point)))
  (setq response (json-reformat json))
  (json-insert-in-current-buffer response (mark) (point)))

(defun json-format-string (json)
  "Formats and displays a json string."
  (interactive "sJson to display (formatted): ")
  (setq response (json-reformat json))
  (json-insert-in-json-buffer response))

(defun json-validate-for-errors (json)
  (setq response (shell-command-to-string (format "echo '%s' | json --validate" json)))
  (if (= (length response) 0)
      (message "No errors found.")
    (message response)))

(defun json-reformat (json)
  (shell-command-to-string (format "echo '%s' | json" json)))

(defun json-insert-in-current-buffer (json start end)
  (delete-region start end)
  (insert json))

(defun json-insert-in-json-buffer (json)
  (json-get-json-buffer)
  (json-insert-in-current-buffer json))

(defun json-get-json-buffer ()
  (set-buffer (get-buffer-create json-validate-display-buffer-name))
  (json-switch-to-js-mode (current-buffer))
  (switch-to-buffer-other-window (current-buffer)))

(defun json-switch-to-js-mode (buffer)
  (setq default-major-mode 'js-mode)
  (set-buffer-major-mode buffer))

(provide 'json-validate)
;;; json-validate.el ends here
