(defsystem "scripts"
  :depends-on (:log4cl :cl-ppcre)
  :components ((:file "package")
	       (:module "lisp"
		:components ((:file "gen-asd")))))
