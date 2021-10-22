#!/bin/sh
iso_file=
disk=
sudo dd bs=4M if=$iso of=$disk conv=fdatasync status=progress
