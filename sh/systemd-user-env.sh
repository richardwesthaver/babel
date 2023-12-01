#!/bin/sh
systemctl --user import-environment DISPLAY XAUTHORITY PATH PYTHON LISP ORGANIZATION # ESHELL EDITOR VISUAL ALTERNATE_EDITOR LANG MANPATH SSH_ASKPASS SSH_AUTH_SOCK PYENV_ROOT
if command -v dbus-update-activation-environment >/dev/null 2>&1; then 
    dbus-update-activation-environment DISPLAY XAUTHORITY
fi
