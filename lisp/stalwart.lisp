;;; stalwart.lisp --- stalwart-mail utils

;; https://stalw.art/docs/directory/types/sql/#sample-directory-schema

;; (ql:quickload :sxql)
;; (ql:quickload :dbi)
;; (load "stalwart")

;;; Code:
(defpackage :stalwart
  (:use :cl :sxql :dbi)
  (:export 
   :init-db :delete-db :init-tables :*db-path*
   :create-accounts-table :create-group-members-table :create-emails-table
   :create-user :create-group :add-alias :add-to-mailing-list :add-to-group))

(in-package :stalwart)

;; #P"/opt/stalwart-mail/data/accounts.sqlite3"
(defparameter *db-path* #P"accounts.sqlite3")

(defun init-db () (dbi:connect :sqlite3 :database-name *db-path*))

(defvar *connection* (init-db))

;; FIXME: set defaults correctly, active = 1, quota = 0
(defun create-accounts-table ()
  (create-table :accounts
        ((name :type 'text
               :primary-key t)
         (secret :type 'text)
         (description :type 'text)
         (type :type 'text)
         (quota :type 'integer)
         (active :type 'boolean))))

(defun create-group-members-table ()
  (create-table :group_members
      ((name :type 'text
             :not-null t)
       (member_of :type 'text
                  :not-null t))
    (primary-key '(:name :member_of))))

(defun create-emails-table ()
  (create-table :emails
      ((name :type 'text
             :not-null t)
       (address :type 'text
                :not-null t)
       (type :type 'text))
    (primary-key '(:name :address))))

;; (insert-user "ellis" "hackme" "r w")
(defun insert-user (name secret full-name)
  (do-sql *connection*
    "INSERT INTO accounts (name, secret, description, type, quota, active) VALUES (?,?,?,'individual',0,1)"
    (list name secret full-name)))

;; (insert-group "mlist" "desc")
(defun insert-group (name description)
  (do-sql *connection*
    "INSERT INTO accounts (name, description, type) VALUES (?,?,'group')"
    (list name description)))

;; (insert-email "ellis" "ellis@c.c")
(defun insert-email (name address &optional (type "primary"))
  (do-sql *connection*
    "INSERT INTO emails (name, address, type) VALUES (?,?,?)"
    (list name address type)))

;; (insert-group-member "ellis" "superusers")
(defun insert-group-member (name group)
  (do-sql
    *connection*
    "INSERT INTO group_members (name, member_of) VALUES (?,?)"
    (list name group)))

;; (create-user "ellis" "ellis@c.c" "hackme" "r w" t)
(defun create-user (name address secret full-name admin)
  (list
   (insert-user name secret full-name)
   (insert-email name address)
   (when admin (insert-group-member name "superusers"))))

;; (defun delete-user (name))

;; (add-alias "ellis" "el@c.c")
(defun add-alias (name alias)
  (insert-email name alias "alias"))

;; (add-to-mailing-list "ellis@c.c" "list@c.c")
(defun add-to-mailing-list (name mlist)
  (insert-email name mlist "list"))

;; (add-to-group "ellis" "groupies")
(defun add-to-group (name group)
  (insert-group-member name group))

;; (create-group "list@c.c" "foobar")
(defun create-group (name description)
  (insert-group name description))

(defun init-tables ()
  (do-sql *connection* (yield (create-accounts-table)))
  (do-sql *connection* (yield (create-emails-table)))
  (do-sql *connection* (yield (create-group-members-table))))

(defun delete-db () (delete-file *db-path*))
