#!/usr/bin/bash
systemctl list-units --state=running | grep -v systemd | awk '{print $1}' | grep service
