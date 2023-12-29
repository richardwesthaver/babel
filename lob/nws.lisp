(defpackage :lob/nws
  (:nicknames :nws)
  (:use :cl :std :sb-ext)
  (:export :weather-report))

(in-package :lob/nws)

(defvar *nws-openapi-json* (octets-to-string (dexador:get "https://api.weather.gov/openapi.json")))
