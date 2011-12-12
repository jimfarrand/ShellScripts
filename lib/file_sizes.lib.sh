
function last_char () {
    sed -ne 's/.*\(.\)/\1/p'
}

function to_bytes {
    echo -e "scale=0\n$1" | sed -e 's/\(.*\)T/\1*1024G/;s/\(.*\)G/\1*1024M/;s/\(.*\)M/\1*1024K/;s/\(.*\)K/\1*1024/;' | bc | sed 's/\([0-9]*\).*/\1/'
}
