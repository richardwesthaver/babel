#!/bin/bash

# store the current dir
CD=$(pwd)

echo "Pulling in latest changes for all local repositories..."

# Find all mercurial repositories, pull and update
for i in $(find . -name ".hg" | cut -c 3-); do
    echo "";
    echo $i;

    # We have to go to the .hg parent directory to call the pull command
    cd "$i";
    cd ..;
    # pull and update
    hg pull -u;
    # go back to the CUR_DIR
    cd $CD
done

echo "Done."
