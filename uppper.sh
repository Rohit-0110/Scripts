#!/bin/bash

while read -p "Enter favorite movie names (or 'exit' to stop): " movie; do
  if [[ "${movie}" == "exit" ]]; then
    break
  fi
  declare -u movie_upper="${movie}"
  echo "${movie_upper}"
done