#!/bin/bash
declare -a todo_list
while read -p "Add items to your to do list (or type 'stop' to stop adding): " todo; do
  if [[ "${todo}" == "stop" ]]; then
    break
  fi
  todo_list+=("${todo}")
done
echo "Current todo list: ${todo_list[@]}"


###


#!/bin/bash
declare -a todo_list
while read -p "Add items to your to do list (or type 'stop' to stop adding): " todo; do
  if [[ "${todo}" == "stop" ]]; then
    break
  fi
  todo_list+=("${todo}")
done
echo "Current todo list: ${todo_list[@]}"
todo_list=("${todo_list[@]: -1}")
echo "Remaining todo list: ${todo_list[@]}"


####

#!/bin/bash
declare -a todo_list
while read -p "Add items to your to do list (or type 'stop' to stop adding): " todo; do
  if [[ "${todo}" == "stop" ]]; then
    break
  fi
  todo_list+=("${todo}")
done
echo "Current todo list: ${todo_list[@]}"
sorted_array=$(printf "%s\n" "${todo_list[@]}" | sort)
printf "%s\n" "Sorted todo list:" ${sorted_array[@]}

