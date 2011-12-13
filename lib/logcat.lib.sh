
# Add the date to the start of each line

function fixnewline {
    if [ -z "$*" ] ; then
        sed -u -e 's/\r/\n/g'
    else
        sed -u -e 's/\r/\n/g' "$@"
    fi 
}

function logcat {
    if [ -z "$LOGCAT_FORMAT"] ; then
        LOGCAT_FORMAT="+%F %T"
    fi

    fixnewline "$@" | while read LINE; do echo "$(date "$LOGCAT_FORMAT") $LINE"; done
}
