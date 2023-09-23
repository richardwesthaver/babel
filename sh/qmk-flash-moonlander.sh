#!/bin/sh
cp -rf ~/dev/cfg/kbd/moonlander/* ~/qmk_firmware/keyboards/moonlander/keymaps/ellis/
qmk flash -kb moonlander -km ellis
