#!/bin/bash
df -h | sed -n '/\budev\b/p' | awk '{ print $4 }'

###

#!/usr/bin/env bash

avail_disk_space=$(df -h | sed -n '/\budev\b/p' | awk '{ print $4 }' | sed 's/G//')
readonly DISK_THRESHOLD=10

if [[ "${DISK_THRESHOLD}" -gt "${avail_disk_space}" ]]; then
    echo "Warning: available disk space is ${avail_disk_space}G. Please maintain a minimum 10G of disk space" | mail -s "Disk Space Alert" your-email@example.com
fi

exit 0