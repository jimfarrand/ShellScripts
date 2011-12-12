
export XYXYX_LOGGER_NULL="/dev/null"
export XYXYX_LOGGER_STDOUT="&1"
export XYXYX_LOGGER_STDERR="&2"

export XYXYX_LOGGER_DEBUG="$XYXYX_LOGGER_STDOUT"
export XYXYX_LOGGER_VERBOSE="$XYXYX_LOGGER_STDOUT"
export XYXYX_LOGGER_INFO="$XYXYX_LOGGER_STDOUT"
export XYXYX_LOGGER_WARN="$XYXYX_LOGGER_STDOUT"
export XYXYX_LOGGER_ERROR="$XYXYX_LOGGER_STDERR"
export XYXYX_LOGGER_DOOM="$XYXYX_LOGGER_STDERR"

export DASH_V="-v"

function log_debug {
    eval "echo >$XYXYX_LOGGER_DEBUG \"\$@\""
}

function log_verbose {
    eval "echo >$XYXYX_LOGGER_VERBOSE \"\$@\""
}

function log_info {
    eval "echo >$XYXYX_LOGGER_INFO \"\$@\""
}

function log_warn {
    eval "echo >$XYXYX_LOGGER_WARN \"\$@\""
}

function log_error {
    eval "echo >$XYXYX_LOGGER_ERROR \"\$@\""
}

function log_doom {
    eval "echo >$XYXYX_LOGGER_DOOM \"\$@\""
}

function log {
    local LEVEL="$1"
    shift
    case "$LEVEL" in
        DEBUG ) log_debug "$@" ;;
        VERBOSE ) log_verbose "$@" ;;
        INFO ) log_info "$@" ;;
        WARN ) log_warn "$@" ;;
        ERROR ) log_error "$@" ;;
        DOOM ) log_doom "$@" ;;
        * ) log_warn "Logging message with invalid level $LEVEL as warn: " "$@"
    esac
}

function set_debug_log {
    XYXYX_LOGGER_DEBUG="$1"
    log_debug "Debug log set to: $1"
}

function set_verbose_log {
    XYXYX_LOGGER_VERBOSE="$1"
    log_debug "Verbose log set to: $1"
}

function set_info_log {
    XYXYX_LOGGER_INFO="$1"
    log_debug "Info log set to: $1"
}

function set_warn_log {
    XYXYX_LOGGER_WARN="$1"
    log_debug "Warn log set to: $1"
}

function set_error_log {
    XYXYX_LOGGER_ERROR="$1"
    log_debug "Error log set to: $1"
}

function set_doom_log {
    XYXYX_LOGGER_DOOM="$1"
    log_debug "Doom log set to: $1"
}

function logging_mode_verbose {
    XYXYX_LOGGER_DEBUG="$XYXYX_LOGGER_NULL"
}

function logging_mode_normal {
    XYXYX_LOGGER_DEBUG="$XYXYX_LOGGER_NULL"
    XYXYX_LOGGER_VERBOSE="$XYXYX_LOGGER_NULL"
    DASH_V=""
}

function logging_mode_quiet {
    XYXYX_LOGGER_DEBUG="$XYXYX_LOGGER_NULL"
    XYXYX_LOGGER_VERBOSE="$XYXYX_LOGGER_NULL"
    XYXYX_LOGGER_INFO="$XYXYX_LOGGER_NULL"
    DASH_V=""
}

function logging_mode_quieter {
    XYXYX_LOGGER_DEBUG="$XYXYX_LOGGER_NULL"
    XYXYX_LOGGER_VERBOSE="$XYXYX_LOGGER_NULL"
    XYXYX_LOGGER_INFO="$XYXYX_LOGGER_NULL"
    XYXYX_LOGGER_WARN="$XYXYX_LOGGER_NULL"
    DASH_V=""
}

function logging_mode_quietest {
    XYXYX_LOGGER_DEBUG="$XYXYX_LOGGER_NULL"
    XYXYX_LOGGER_VERBOSE="$XYXYX_LOGGER_NULL"
    XYXYX_LOGGER_INFO="$XYXYX_LOGGER_NULL"
    XYXYX_LOGGER_WARN="$XYXYX_LOGGER_NULL"
    XYXYX_LOGGER_ERROR="$XYXYX_LOGGER_NULL"
    DASH_V=""
}

function logging_mode_silent {
    XYXYX_LOGGER_DEBUG="$XYXYX_LOGGER_NULL"
    XYXYX_LOGGER_VERBOSE="$XYXYX_LOGGER_NULL"
    XYXYX_LOGGER_INFO="$XYXYX_LOGGER_NULL"
    XYXYX_LOGGER_WARN="$XYXYX_LOGGER_NULL"
    XYXYX_LOGGER_ERROR="$XYXYX_LOGGER_NULL"
    XYXYX_LOGGER_DOOM="$XYXYX_LOGGER_NULL"
    DASH_V=""
}
