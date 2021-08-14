#!/bin/bash

# Don't needlessly use Bash-only syntax for declaring a function
# Indent the code
video () {
  youtube-dl --no-warnings \
      -o '~/stash/tmp/%(title)s.%(ext)s' \
      --socket-timeout 15 --hls-use-mpegts -R 64 --fragment-retries 64 \
      --prefer-free-formats --all-subs --embed-subs \
      -f 'bestvideo[height<=1080]+bestaudio/best[height<=1080]' "$@" \
      --restrict-filenames
}

until video "$@"; do
    sleep 5
done
