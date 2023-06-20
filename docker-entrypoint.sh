#!/bin/sh

# CHECK DIR CONTENTS
CONTENT=$(ls -A)
CONTENT_LENGTH=$(echo -n $CONTENT | wc -m)

# IF DIR EMPTY, OR ONLY GIT DIR PRESENT
if [ $CONTENT_LENGTH == "0" ] || [ "$CONTENT" == ".git" ]; then

    # INIT NEW BOOK
    printf 'y\n \n' | mdbook init --force --theme
fi

# IF NO FIRST ARG SUPPLIED OR FIRST ARG IS "serve"
if test -z $1 || [ "$1" == "serve" ]; then

    # START SERVING BOOK
    mdbook serve --hostname 0.0.0.0 --port 3000
    exit $?
fi

# IF PARAMS SUPPLIED, PASS THEM TO MAIN COMMAND
mdbook $@