#!/usr/bin/env bash

/usr/local/bin/filereader

echo $?

echo "Shouldn't reach this line"

exit 0


###
set -e

/usr/local/bin/filereader

echo "Shouldn't reach this line"

exit 0


###
#!/usr/bin/env bash
set -e

if [[ $# -ne 1 || ! -s "${1}" ]]; then
     echo "Please pass just one command line argument as a file that exists and is non-empty"
     exit 155
fi

/usr/local/bin/filereader "${1}"

echo "Shouldn't reach this line"

exit 0

/home/bob/special-shell.sh /home/bob/test.txt


###
#!/usr/bin/env bash
set -e

readonly INVALID_CL_ARG_NUM="155"

terminate() {
    local -r msg="${1}"
    local -r code="${2:-150}"
    echo "${msg}" >&2
    exit "${code}"
}

if [[ $# -ne 1 || ! -s "${1}" ]]; then
    terminate "Please pass just one command line argument as a file that exists and is non-empty" "${INVALID_CL_ARG_NUM}"
fi

/usr/local/bin/filereader "${1}"

exit 0

/home/bob/special-shell.sh /home/bob/test.txt /home/bob/test.txt
echo $?


###
#!/usr/bin/env bash
set -e

readonly INVALID_CL_ARG_NUM="155"

terminate() {
    local -r msg="${1}"
    local -r code="${2:-150}"
    echo "${msg}" >&2
    exit "${code}"
}

usage() {

cat <<USAGE
Usage: special-shell.sh [arg]
   This script reads the contents from a file using a filereader binary
   Arguments: 
       filename: An existing non-empty file

USAGE
}

if [[ $# -ne 1 || ! -s "${1}" ]]; then
    usage
    terminate "Pass a single command line argument as a file that exists and is non-empty" "${INVALID_CL_ARG_NUM}"
fi

/usr/local/bin/filereader "${1}"

exit 0

/home/bob/special-shell.sh /home/bob/test.txt


###

#!/usr/bin/env bash

# Check if no arguments are passed  
if [[ $# -eq 0 ]]; then  
    echo  "Please provide names as arguments."
    exit 1 
fi  

# Loop through all arguments using special shell variable $@  
for name in  "$@"; do  
    echo  "Hello, ${name}!" 
done


/home/bob/special-at.sh Feng Debbie Andy