#!/bin/sh
openssl x509 -in ${1} -noout -enddate
openssl x509 -in libera.pem -noout -fingerprint -sha512 | awk -F= '{gsub(":",""); print tolower ($2)}'
