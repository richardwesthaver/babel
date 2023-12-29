#!/bin/sh

# take screenshot on X11

import png:- >> ${1:-"$(date +%s).png"}
