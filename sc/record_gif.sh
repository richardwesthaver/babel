#!/usr/bin/bash
# Wrapper for t-rec program
t-rec -l
read -p "WINDOWID = " recwin
WINDOWID=$recwin t-rec -d none -b black -mqn -s 1s -e 2s
