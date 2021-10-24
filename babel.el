;;; babel.el --- meta-programming extensions         -*- lexical-binding: t; -*-
;; 
;; Copyright (C) 2021  ellis
;; 
;; Author: ellis <ellis@rwest.io>
;; Version: 0.1.0
;; Package-Requires: ((emacs "28"))
;; Keywords: convenience, abbrev, tools, languages, lisp, files, c, extensions
;; 
;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;; 
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;; 
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.
;; 
;;; Commentary:
;; 
;; This package contains the editor integration for `babel`, which is
;; a spiritual descendent of the Library of Babel (`ob-lob.el`).
;;
;;; Code:
(defgroup babel ()
  "Meta-programming extensions"
  :group 'shed)

(defcustom babel-skeleton-autoinsert nil
  "Non-nil means babel template skeletons will be inserted automagically using abbrevs."
  :type 'boolean
  :group 'babel
  :safe 'booleanp)

(defvar babel-skeleton-alist '()
  "Internal list of available skeletons.")

(define-abbrev-table 'babel-skeleton-abbrev-table ()
  "Abbrev table for Babel skeletons"
  :case-fixed t
  ;; Allow / inside abbrevs.
  :regexp "\\(?:^\\|[^/]\\)\\<\\([[:word:]/]+\\)\\W*")

(defmacro babel-skeleton-define (name doc &rest skel)
  "Define a Babel skeleton using NAME DOC and SKEL.
The skeleton will be bound to `babel-skeleton-NAME and added to
`babel-skeleton-abbrev-table`"
  (declare (indent 2))
  (let* ((name (symbol-name name))
         (function-name (intern (concat "babel-skeleton-" name))))
    `(progn
       (define-abbrev babel-skeleton-abbrev-table
         ,name "" ',function-name :system t)
       (setq babel-skeleton-alist
             (cons ',function-name babel-skeleton-alist))
       (define-skeleton ,function-name
         ,(or doc
              (format "Insert %s statement." name))
         ,@skel))))

(define-abbrev-table 'babel-abbrev-table ()
  "Abbrev table for Babel."
  :parents (list babel-skeleton-abbrev-table))

(provide 'babel)
;;; babel.el ends here
