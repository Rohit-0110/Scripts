#!/bin/bash

# This is the log file we're interested in
logfile="/etc/logs/error.log"

echo "Number of times each error message appears:"
# Your code here
cat "${logfile}" | grep "DB_CONN_FAILURE" | sort | uniq -c


###
sh log_parser.sh > stdout.txt 2>stderr.txt