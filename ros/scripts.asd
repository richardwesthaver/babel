(asdf:defsystem scripts
  :version "0.1.0"
  :serial t
  :components ((:file "log-test"))
  :depends-on (:cl-ppcre
	       :usocket
	       :promise
	       :verbose
	       :alexandria
	       :cffi
	       :bordeaux-threads))
