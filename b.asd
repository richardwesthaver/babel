(defsystem :b
  :version "0.1.0"
  :description "babel"
  :class :package-inferred-system
  :defsystem-depends-on (:asdf-package-system)
  :depends-on (:sxql :dbi :cl-ppcre :std :b/all))
