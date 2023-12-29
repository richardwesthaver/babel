;;; wayland utils

;; we currently use the wayflan library for wayland hacking.

;;; Code:
(defpackage :lob/wl-utils
  (:nicknames :stalwart)
  (:use :cl :std :wayflan-client)
  (:export))

(in-package :lob/wl-utils)

(defun sanity-check ()
  (with-open-display (d)
    (let ((reg (wl-display.get-registry d)))
      (prog1 (values d reg)
        (wl-display-roundtrip d)))))
