#!/usr/bin/env bash
readonly TAG=emacs-29.0.92
readonly REPOSITORY=git://git.savannah.gnu.org/emacs.git
readonly CONFIGURE_OPTIONS=(--with-mailutils
			    --with-imagemagick
			    --with-x-toolkit=gtk
			    --without-pop
			    --without-sound
			    --with-json
			    --enable-link-time-optimization
			    --with-native-compilation
			    --with-modules)

readonly PROGRAM=emacs
TEMACS=/tmp/$TAG
# source common.sh

function pull() {
    git clone $REPOSITORY $TEMACS
}
function prep() {
    cd "$TEMACS"
    ./autogen.sh
    case "$PLATFORM" in
        mac) ./configure --prefix="$INSTALL_DIR" --with-ns --disable-ns-self-contained "${CONFIGURE_OPTIONS[@]}" ;;
        *)   ./configure --prefix="$INSTALL_DIR" "${CONFIGURE_OPTIONS[@]}" ;;
    esac
}

function build() {
    cd "$TEMACS"
    NATIVE_FULL_AOT=1 make -j $MAXCPUS
}

function install() {
    cd "$TEMACS"
    # Ensure we clear out previous install
    rm -R "$INSTALL_DIR/"
    
    make install datadir="$INSTALL_DIR/share/"

    status 2 "Copying dependencies"
    ensure-dependencies $(find-binaries "$INSTALL_DIR/")

    cp "$SCRIPT_DIR/config/site-start.el" "$INSTALL_DIR/share/emacs/site-lisp/site-start.el" \
        || eexit "Couldn't copy site file to correct site-lisp dir"

    case "$PLATFORM" in
        lin) cp "/usr/bin/xsel" "$SHARED_BIN_DIR/" \
                || eexit "Could not find xsel."
             ensure-dependencies "$SHARED_BIN_DIR/xsel"
             ;;
        mac) mac-fixup-dependencies "$INSTALL_DIR/bin/emacs"
             mac-fixup-dependencies "$INSTALL_DIR/bin/$TAG"
             mac-fixup-lib-dependencies
             ;;
    esac
}

prepare
build
