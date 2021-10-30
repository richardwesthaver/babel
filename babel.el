;;; babel.el --- meta-programming extensions         -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2021  ellis
;; 
;; Author: ellis <ellis@rwest.io>
;; Version: 0.1.0
;; Package-Requires: ((emacs "28") (ob-async "0.1"))
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
(require 'ob-async)

(defgroup babel ()
  "Meta-programming extensions"
  :group 'shed)
 
(defcustom lob-file-name "~/shed/src/babel/lob.org"
  "Filename for an org-mode buffer containing the Library of Babel"
  :type 'string
  :group 'babel
  :safe 'stringp)

(defcustom lob-ingest-trigger 'on-save
  "Control when 'org-babel-lob-ingest` will be executed."
  :type '(choice (const :tag "Ingest on `lob-file` save." on-save)
		 (const :tag "JIT Ingestion." jit)
		 (const :tag "Trigger lob-ingest manually." nil))
  :group 'babel)

(defvar lob-file (expand-file-name lob-file-name))

(defun lob-file-active-p ()
  "Non-nil if the active buffer is `lob-file`"
  (string= (buffer-file-name) lob-file))

;;;; Hooks 
(defun lob-after-save-hook ()
  "lob.org `after-save-hook` when lob-ingest-trigger = on-save
and `lob-file-active-p` is non-nil."
  (when (and (eq lob-ingest-trigger 'on-save)
	     ( lob-file-active-p))
    (org-babel-lob-ingest lob-file)))
 
;;;###autoload
(add-hook 'after-save-hook #'lob-after-save-hook)
;;;###autoload
(add-hook 'org-load-hook (lambda () (org-babel-lob-ingest lob-file)))

;;;; Macros
(defun babel--mode-prefix (mode)
  "Return MODE name or empty string in nil."
  (if mode
      (string-trim-right (symbol-name mode) (rx "mode" eos))
    ""))
(defun babel--abbrev-table (mode)
  "Get abbrev table for MODE or `global-abbrev-table' if nil."
  (if mode
      (derived-mode-abbrev-table-name mode)
    'global-abbrev-table))

(defun org-sbx-call (name header args)
  (let* ((args (mapconcat
                (lambda (x)
                  (format "%s=%S" (symbol-name (car x)) (cadr x)))
                args ", "))
         (ctx (list 'babel-call (list :call name
                                      :name name
                                      :inside-header header
                                      :arguments args
                                      :end-header ":results silent")))
         (info (org-babel-lob-get-info ctx)))
    (when info (org-babel-execute-src-block nil info))))

(defmacro org-sbx (name &rest args)
  (let* ((header (if (stringp (car args)) (car args) nil))
	 (args (if (stringp (car args)) (cdr args) args)))
    (unless (stringp name)
      (setq name (symbol-name name)))
    (let ((result (org-sbx-call name header args)))
      (org-trim (if (stringp result) result (format "%S" result))))))

;;;; Skeletons 
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
The skeleton will be bound to babel-skeleton-NAME and added to
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

(defmacro babel-define-aux-skeleton (name &optional doc &rest skel)
  "Define a Babel auxiliary skeleton using NAME DOC and SKEL.
The skeleton will be bound to babel-skeleton-NAME."
  (declare (indent 2))
  (let* ((name (symbol-name name))
         (function-name (intern (concat "babel-skeleton--" name)))
         (msg (funcall (if (fboundp 'format-message) #'format-message #'format)
                       "Add `%s' clause? " name)))
    (when (not skel)
      (setq skel
            `(< ,(format "%s:" name) \n \n
                > _ \n)))
    `(define-skeleton ,function-name
       ,(or doc
            (format "Auxiliary skeleton for %s statement." name))
       nil
       (unless (y-or-n-p ,msg)
         (signal 'quit t))
       ,@skel)))

(babel-define-aux-skeleton else)
(babel-define-aux-skeleton except)
(babel-define-aux-skeleton then)
(babel-define-aux-skeleton while)

(define-abbrev-table 'babel-abbrev-table ()
  "Abbrev table for Babel."
  :parents (list babel-skeleton-abbrev-table))

(define-skeleton local-variables-section                                  
 "Insert a local variables section.  Use current comment syntax if any."  
 (completing-read "mode: " obarray                                        
                (lambda (symbol)                                          
                  (if (commandp symbol)                                   
                      (string-match "-mode$" (symbol-name symbol))))      
                t)                                                        
 '(save-excursion                                                         
    (if (re-search-forward page-delimiter nil t)                          
      (error "Not on last page")))                                        
 comment-start comment-start " local-vars:" comment-end \n                          
 comment-start comment-start " - mode: " str                                               
 & -5 | '(kill-line 0) & -1 | comment-end \n                              
 ( (completing-read (format "var, %s: " skeleton-subprompt)          
                  obarray                                                 
                  (lambda (symbol)                                        
                    (or (eq symbol 'eval)                                 
                        (custom-variable-p symbol)))                      
                  t)                                                      
   comment-start comment-start " - " str ": "                                                 
   (read-from-minibuffer "expr: " nil read-expression-map nil       
                       'read-expression-history) | _                      
   comment-end \n)                                                        
 resume:                                                                  
 \n)                                     

(define-skeleton rust-fn
  "Insert a Rust function."
  nil
  > "fn " _ " {" \n
  > \n
  "}" > \n)

;;;; pkg 
(provide 'babel)
;;; babel.el ends here
