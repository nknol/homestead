#!/usr/bin/env bash

# Isolate the directory name
STRING=${1##*/}
SOMEDIR=$2/${STRING//.git/$replace}

#check for directory and clone if not there
if [ -d "$SOMEDIR" ]; then
    echo "$STRING repo exists."
else
    cd $2 && git clone $1
fi

