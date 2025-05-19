# VARIBALES
FILE=""
SOURCE_FILE=""
WORK_DIR=""
DEST_FILE=""

export SOURCE_FILE

# FUNCTION

func() {

}
calculate_area() {

}
clone_repo() {

}


# EXPANDING
#!/bin/bash
var="value of var"
echo ${var}


#!/bin/bash
string="1 2 3"

# without ""                
for element in ${string}; do
    echo ${element}
done

# output 
1
2
3

# with ""
for element in "${string}"; do
    echo ${element}
done

# output
1 2 3


readonly SERVER="server1 server2 server3"
for server in ${SERVER}; do
    echo "${server}.kodekloud.com"
done

# SCRIPT FLOW

# Conditional Statement
#!/bin/bash
if [[ 3 > 4 ]]; then
    echo "you will not reach this line of code"
fi

# CASE
case word in
    pattern1)
        Statement(s)
        ;;
    pattern1)
        Statement(s)
        ;;
    pattern1)
        Statement(s)
        ;;
    *) 
        Default condition to be executed
        ;;
    esac

# LOOPS
# FOR LOOP
#!/bin./bash
for i in {1..3}; do
    # Do something on each iteration
    echo "Iteration $i"
done

#!/bin/bash
for i in $(seq 1 3); do
    # Do something on each iteration
    echo "Iteration $i"
done


# WHILE LOOP
#!/bin/bash
i=1

# loop 3 times
while [[ $i -le 3 ]]; do
    # Do something on each iteration
    echo "Iteration $i"
    # Increment counter variable
    i=$((i+1))
done

# UNTIL LOOP
#!/bin/bash
i=3

# loop 3 times
until [[ $i -eq 0 ]]; do
    # Do something on each iteration
    echo "Iteration $i"

    # Decrement Counter variable
    i=$((i-1))
done

---

$ cat .conf
name="text"

#!/bin/bash
source .conf
echo "${name}"

# output
text

---

# for file condition option check
file --help

#!/bin/bash
readonly CONF_FILE=".conf"

if [[ -f ${CONF_FILE} ]]; then
    source "${CONF_FILE}"
else
    name="bob"
fi

echo "${name}"

exit 0

---

#function
#!/bin/bash
perform_backup() {
    mkdir backup
    cd backup
    cp -r ${1} .
    tar -czvf backup.tar.gz *
    echo "Backup complete!"
}

perform_backup ${1}

exit 0

----
 
#!/bin/bash
git_url=${1}

clone_git() {
    # clone git repo
    git clone ${1}
}

find_files() {
    # Count number of files
    find . -type f | wc -l
}

clone_git "${git_url}"
find_files

---

#!/bin/bash

fucntion my_function() {
    local var1="Hello"
    echo "${var1}"
}

my_function

---


$ ./script.sh arg1 arg2 arg3

#!/bin/bash
echo "first argument: $1"
shift
echo "second argument: $1"
shift
echo "Third argument: $1"

$ ./script.sh 1 2 3
first argument: 1
second argument: 2
Third argument: 3

---

# Shebang

sudo strace -Tfp $$ 2>&1 | grep -E 'execve' &

vim ~/.bashrc
export PATH="/opt/homebrew/bin:$PATH"

source ~/.bashrc

Portable 
#!/usr/bin/env bash

---

# stdout
ls -z 1> test2.txt
$ cat test2.txt

# stderr
ls -z 2> test2.txt
$ cat test2.txt
ls: invalid option -- 'z'
Try 'ls --help' for more information.

---

[~/Downloads] $ ls -l &> test.txt
[~/Downloads] $ cat test
[~/Downloads] $ cat test.txt
total 9320
-rw-rw-r-- 1 rohit rohit 2758923 Aug 28 21:13 ArgoCD.pdf
-rw-rw-r-- 1 rohit rohit 1670838 Aug 30 22:29 francesco-ungaro-pt8iGHS7Zug-unsplash.jpg
-rw-rw-r-- 1 rohit rohit  645532 Aug 30 20:00 golang.Go-0.42.0.vsix


------------------------------------------------------------


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


------------------------------------------------------------

sudo docker ps -aq | sudo xargs docker rm
cat urls.txt | xargs curl -I