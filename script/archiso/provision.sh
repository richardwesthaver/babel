#!/usr/bin/sh

set -e

CFG=$HOME/src/config/zor/sys/archiso/arch-tui
WD=$HOME/stash/tmp/archiso-wd
OUT=$HOME/stash/tmp/archiso

passgen() {
		openssl passwd -6
}

mkiso() {
		mkdir -p $WD $OUT
		mkarchiso -v -w $WD -o $OUT $CFG
		rm -rf $WD
}

test() {
		run_archiso -i $OUT/*
}

clean() {
		rm -rf $WD $OUT
}

main() {
mkiso
test
}

main
