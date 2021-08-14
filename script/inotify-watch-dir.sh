#!/usr/bin/bash
read -p "path to watch: " path
inotifywait -m  $path -e create -e moved_to |
    while read dir action file; do
	echo "The file '$file' appeared in directory '$dir' via '$action'"
    done
