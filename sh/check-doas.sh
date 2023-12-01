#!/usr/bin/bash
# chown -c root:root /etc/doas.conf
# chmod -c 0400 /etc/doas.conf
# alias sudo='doas'
# alias sudoedit='doas emacs'
doas -C /etc/doas.conf && echo "config ok" || echo "config error"
