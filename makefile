BIN_DIR=~/.local/bin/
i:py/* sh/* hs/* ps/*;mkdir -p $(BIN_DIR);cp -r $^ $(BIN_DIR)
