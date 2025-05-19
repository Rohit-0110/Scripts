#!/bin/bash
project=${1}
branch=${2}

# guard clause 
if [[ -z "${project}" ]]; then
   echo "Error: Git project is not specified"
   exit 1
fi

project_dir="$(basename ${project} .git)"

clone_project() {
  if [ ! -d "/home/bob/git/${project_dir}" ]; then
    cd /home/bob/git/
    git clone ${project}
  fi
}
git_checkout() {
  cd "/home/bob/git/${project_dir}"
  # it will go with default branch is branch not specified
  if [[ ! -z "${branch}" ]]; then   
    git checkout "${branch}" ||  echo "Error: Branch ${branch} doesn't exist in ${project}." exit 1 ; exit 1
  fi
}

find_files() {
  find . -type f | wc -l
}
clone_project
git_checkout
find_files

# basename output git
basename /home/bob/git



###

#!/bin/bash

project=${1}
branch=${2}

if [[ -z "${project}" ]]; then
   echo "Error: Git project not specified"
   exit 1
fi

project_dir="$(basename "${project}" .git)"

clone_project() {
  if [[ ! -d "${project_dir}" ]]; then
    git clone ${1}
  fi
}

find_files() {
  find ${1} -type f | wc -l
}

git_checkout() {
  cd "${1}"
  if [[ ! -z "${branch}" ]]; then
    git checkout "${branch}" ||echo "Error: Branch ${branch} doesn't exist in ${project}."; exit 1
  fi
}

clone_project "${project}"
git_checkout "${project_dir}"
find_files "."



####
[bob@student-node script]$ sudo find / -type f -name "question8_directory"
/etc/question8_directory
find: ‘/proc/tty/driver’: Permission denied
find: ‘/sys/kernel/slab/kmalloc-32/cgroup/kmalloc-32(1196508:6a38edcf1ae5a99c52e25fa02f7179c0d0910daab28f677918df6392f3e6b414)’: No such file or directory
[bob@student-node script]$ sudo find / -type f -name "question8_directory" 2> /dev/null
/etc/question8_directory
