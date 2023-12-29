#!/bin/sh
systemctl --user import-environment DISPLAY PATH PYTHON LISP ORGANIZATION ESHELL EDITOR VISUAL ALTERNATE_EDITOR LANG MANPATH SSH_AUTH_SOCK PYENV_ROOT # XAUTHORITY SSH_ASKPASS
if command -v dbus-update-activation-environment >/dev/null 2>&1; then 
    dbus-update-activation-environment DISPLAY # XAUTHORITY
fi
