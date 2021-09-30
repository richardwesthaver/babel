#!/bin/sh

set -euC

cd ~

att() {
    [ -n "${TMUX:-}" ] &&
        tmux switch-client -t '=site' ||
        tmux attach-session -t '=site'
}

if tmux has-session -t '=site' 2> /dev/null; then
    att
    exit 0
fi

tmux new-session -d -s site

tmux new-window -d -t '=site' -n server -c ~/_site
tmux send-keys -t '=site:=server' 'python -mhttp.server' Enter

tmux new-window -d -t '=site' -n jekyll
tmux send-keys -t '=site:=jekyll' 'JEKYLL_NO_BUNDLER_REQUIRE=1 jekyll build -w' Enter

att
