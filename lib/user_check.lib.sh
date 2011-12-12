
function require_root () {
    if [ "$(whoami)" == root ] ; then
        log_debug "root confirmed"
    else
        if [ -n "$1" ] ; then
            log_error "$1"
            exit 1
        else
            log_error "Root required"
            exit 1
        fi
    fi
}
