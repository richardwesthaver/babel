BIN_DIR=~/.local/bin
LIB_DIR=~/.local/lib
BIN_SRC=py/* sh/* hs/* ps/*
LIB_SRC=all.lisp lisp/*
ASD=b.asd
install:$(BIN_DIR) $(LIB_DIR) $(LIB_DIR)/lisp/core
.PHONY:$(BIN_SRC) $(LIB_SRC) core
ql:;ln -sf $(realpath $(ASD)) ~/quicklisp/local-projects/$(ASD)
$(BIN_SRC):;chmod +x $@
$(LIB_DIR)/lisp/core:sh/sbcl-save-core.sh;
	mkdir -pv $@
	$< "$@/std.core"
	$< "$@/lib.core" "(mapc #'ql:quickload (list :dot :nlp :rdb :organ :packy :skel))"
	$< "$@/cli.core" "(ql:quickload :std/cli)"
$(BIN_DIR):$(BIN_SRC);mkdir -p $@;cp -r $^ $@
$(LIB_DIR):$(LIB_SRC);mkdir -p $@/lisp/b;cp -r $^ $@/lisp/b;cp $(ASD) $@/lisp
