
# Put this code at the top of the scripts
## xyxyx script initialisation code
#if [ -f "$JIMS_SHELLSCRIPTS/loader" ] ; then source "$JIMS_SHELLSCRIPTS/loader"
#else echo "Couldn't load xyxyxbash"; exit 1; fi
## See $JIMS_SHELLSCRIPTS/doc/README

function check_environment {
    if [ -z "$JIMS_SHELLSCRIPTS" ] ; then
        echo "\$JIMS_SHELLSCRIPTS not set"
        return 1
    fi

    if [ ! -d "$JIMS_SHELLSCRIPTS" ] ; then
        echo "\$JIMS_SHELLSCRIPTS=\"$XYXYBASH\" is not a directory"
        return 1
    fi
}

function do_config {
    JIMS_SHELLSCRIPTS_SCRIPTS="$JIMS_SHELLSCRIPTS/bin"
    JIMS_SHELLSCRIPTS_LIBRARY="$JIMS_SHELLSCRIPTS/lib"
}

function xyxyxlib_lib_status {
    local LIB_NAME="$1"
    local VAR="echo \"\$JIMS_SHELLSCRIPTS_LIB_STATUS_$LIB_NAME\""
    eval "$VAR"
}

function xyxyxlib_set_lib_status {
    local LIB_NAME="$1"
    local VAL="$2"
    eval "export JIMS_SHELLSCRIPTS_LIB_STATUS_$LIB_NAME=\"$VAL\""
}

function xyxyxlib {
    check_environment || return $?
    do_config || return $?
    local LIB_NAME LIB_STATUS LIB_LOCATION
    for LIB_NAME in "$@" ; do
        LIB_LOCATION="$JIMS_SHELLSCRIPTS_LIBRARY/$LIB_NAME.lib.sh"
        LIB_STATUS="$(xyxyxlib_lib_status "$LIB_NAME")"
        #echo "Status is $LIB_STATUS"
        if [ "$LIB_STATUS" = loaded ] ; then
            # Alreaded loaded
            # echo "Already loaded $LIB_NAME"
            return 0
        elif [ "$LIB_STATUS" = loading ] ; then
            log_verbose "Ignoring recursive import of $LIB_NAME"
            return 0
        elif [ -f "$LIB_LOCATION" ] ; then
            log_debug "Loading $LIB_NAME"
            xyxyxlib_set_lib_status "$LIB_NAME" loading
            source "$LIB_LOCATION"
            xyxyxlib_set_lib_status "$LIB_NAME" loaded
            log_debug "Loaded $LIB_NAME"
        else
            log_error "Couldn't find lib $LIB_NAME ($LIB_LOCATION)"
            return 1
        fi
    done
}

function add_xyxyxbash_to_path_after {
    xyxyxlib path_utils
    log_debug "Adding xyxyxbash scripts to path"
    add_path_after "$JIMS_SHELLSCRIPTS_SCRIPTS"
}

check_environment || return $?
do_config || return $?
xyxyxlib_set_lib_status "logging" loading
source "$JIMS_SHELLSCRIPTS_LIBRARY/logging.lib.sh"
xyxyxlib_set_lib_status "logging" loaded
