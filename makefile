BIN_DIR=~/.local/bin
LIB_DIR=~/.local/lib
BIN_SRC=py/* sh/* hs/* ps/*
LIB_SRC=lob
ASD=lob/lob.asd
install:$(BIN_DIR) $(LIB_DIR) $(LIB_DIR)/lisp/fasl
.PHONY:$(BIN_SRC) $(LIB_SRC) core
ql:;ln -sf $(realpath $(ASD)) ~/quicklisp/local-projects/$(ASD)
$(BIN_SRC):;chmod +x $@
$(LIB_DIR)/lisp/fasl:sh/sbcl-save-core.sh;
	mkdir -pv $@
	$< "$@/std.core"
	$< "$@/prelude.core" "(mapc #'ql:quickload \
	(list :nlp :rdb :organ :packy :skel :obj :net :parse :pod :dat :log :packy :rt :sxp :syn :xdb))"
	$< "$@/rdb.core" "(ql:quickload :rdb)"
	$< "$@/organ.core" "(ql:quickload :organ)"
	$< "$@/skel.core" "(ql:quickload :skel)"
	$< "$@/pod.core" "(ql:quickload :pod)"
	$< "$@/cli.core" "(ql:quickload :cli)"
$(BIN_DIR):$(BIN_SRC);mkdir -p $@;cp -r $^ $@
$(LIB_DIR):$(LIB_SRC) $(ASD);mkdir -p $@/lisp;cp -rf $^ $@/lisp/;
