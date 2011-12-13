
function lock_file {
    local FILE="$1"
    [ -n "$FILE" ] || { echo "lock_file <file>" ; return 1 ; }
    local LOCK_FILE="$FILE.lock"

    log_debug "Aquiring lock $LOCK_FILE"

    if ! ln -s "$FILE" "$LOCK_FILE" 2>/dev/null ; then
        log_warn "Waiting for lock file: $LOCK_FILE"
        while ! ln -s "$FILE" "$LOCK_FILE" 2>/dev/null ; do
            sleep 1
        done
    fi

    log_debug "Aquired lock file $LOCK_FILE"
}

function unlock_file {
    local FILE="$1"
    [ -n "$FILE" ] || { echo "unlock_file <file>" ; return 1 ; }
    local LOCK_FILE="$FILE.lock"
    local TEMP_FILE="$FILE.deleteme.$RANDOM"
    log_debug "Releasing lock file $LOCK_FILE"
    mv "$LOCK_FILE" "$TEMP_FILE" || { echo "failed to move lock file" ; return 1 ; }
    log_debug "Released lock file $LOCK_FILE"
    rm "$TEMP_FILE"
    return 0
}

function pid_lock_file {
    local TARGET="$$"
    [ -n "$TARGET" ] || { echo "pid_lock_file <file>" ; return 1 ; }
    local LOCK_FILE="$1.lock"

    log_debug "Aquiring lock $LOCK_FILE for $TARGET"

    if ! ln -s "$TARGET" "$LOCK_FILE" 2>/dev/null ; then
        OWNER="$(readlink "$LOCK_FILE")"
        if [ -z "$OWNER" ] || ! ps >/dev/null -p "$OWNER" ; then
            log_debug "Lock $LOCK_FILE owned by dead process"
            rm $DASH_V "$LOCK_FILE"
            if ! ln -s "$TARGET" "$LOCK_FILE" 2>/dev/null ; then
                log_error "Failed to aquire lock: $LOCK"
                return 1
            fi
        else
            log_debug "Lock owned by $OWNER"
            return 1
        fi
    fi

    log_debug "Aquired lock file $LOCK_FILE"
}

