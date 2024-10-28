#!/bin/bash
declare -A email_address=(
 ["Mark"]="mark@kodekloud.com"
 ["Kriti"]="kriti@kodekloud.com"
 ["Enrique"]="enrique@kodekloud.com"
 ["Feng"]="feng@kodekloud.com"
)
for key in "${!email_address[@]}"; do
  echo "${key}'s email is ${email_address[${key}]}"
done

