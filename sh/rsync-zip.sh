#!/usr/bin/env bash
zip $2.zip $2 && rsync -av -e $1 $2.zip $3
