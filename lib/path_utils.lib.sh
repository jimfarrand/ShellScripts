#!/bin/bash

function require_in_path {
    local NAME="$1"
    local LOCATION R
    if ! LOCATION="$(which "$NAME")" ; then
        log_error "Couldn't find command: $NAME in $PATH"
        exit 1
    else
        log_debug "Found $NAME at: $LOCATION"
    fi
}

function add_path_after {
    local NAME="$1"
    if echo "$PATH" | grep --quiet "$NAME\(:\|$\)" ; then
        log_debug "Not adding $NAME to path: already present"
    else
        export PATH="$PATH:$NAME"
        log_debug "Adding $NAME to path; path now: $PATH"
    fi
}
