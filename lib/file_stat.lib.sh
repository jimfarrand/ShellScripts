
# File modification time, seconds since epoch

function file_modification_time {
   local FILE="$1"
   [ -e "$FILE" ] || { log_error "Couldn't find file: $FILE" ; return 1 ; }
   stat --format='%Y' "$FILE"
}

