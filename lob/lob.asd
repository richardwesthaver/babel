(defsystem :lob
  :version "0.1.0"
  :description "babel"
  :class :package-inferred-system
  :defsystem-depends-on (:asdf-package-system)
  :depends-on (:sxql :dbi :dexador :cl-ppcre :std :lob/all :sb-bsd-sockets :wayflan-client))
