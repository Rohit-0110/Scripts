#!/usr/bin/env bash

file_url="https://raw.githubusercontent.com/kodekloudhub/solar-system-9/main/app.tar.gz"
remote_dir="/home/bob/nodejs/kodekloud-lab6"
remote_user="bob"
remote_server="localhost"
spin_script_path="/home/bob/spin.sh"

# Function to start the spinner
start_spinner() {
    echo "Beginning the Package Download..."
    source "${spin_script_path}" &
    spin_pid=$!
}

# Function to stop the spinner
stop_spinner() {
    kill "${spin_pid}" >/dev/null 2>&1
    echo "Download complete!"
}

# Function to download and set up the app
download_file() {
    for server in $remote_server; do
        ssh -q "${remote_user}@${server}" <<EOF
        cd ${remote_dir}
        wget -q "${file_url}"
        tar -xzf app.tar.gz
        mv app/* .
        npm install express >/dev/null 2>&1
        node app1.js >/dev/null 2>&1 &
        node app2.js >/dev/null 2>&1 &
        node app3.js >/dev/null 2>&1 &
EOF
    done
}

# Main execution
start_spinner
download_file
stop_spinner