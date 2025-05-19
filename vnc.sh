#!/bin/bash

# File where entries are stored
FILE="/usr/vnc/vncserver.users"
LOG_FILE="/tmp/vncscript.log"

# Get the logged-in user
USERNAME=$(whoami)

# Check if the user already exists in the file
if grep -q "=$USERNAME" "$FILE"; then
# Extract and display the assigned display number for the user
    DISPLAY_NUM=$(grep "=$USERNAME" "$FILE" | cut -d '=' -f 1)
    echo "User $USERNAME already exists with display number $DISPLAY_NUM, executing default shell..." >> "$LOG_FILE"
    echo "User $USERNAME already exists with display number $DISPLAY_NUM"
    exec $SHELL
fi

# Find the last assigned number (if any)
if [ -f "$FILE" ]; then
    LAST_NUM=$(grep -oP "^:\d+" "$FILE" | sed 's/^://' | sort -n | tail -1)
else
    LAST_NUM=0
fi

# Increment the number
NEW_NUM=$((LAST_NUM + 1))

# Append the new entry
echo ":$NEW_NUM=$USERNAME" >> "$FILE"
echo "Entry added: :$NEW_NUM=$USERNAME" >> "$LOG_FILE"

echo "Assigned display number for user $USERNAME is :$NEW_NUM"



---------------------------------
# WITH SERVICE ----
#!/bin/bash

# File where entries are stored
FILE="/usr/vnc/vncserver.users"
LOG_FILE="/tmp/vncscript.log"

# Get the logged-in user
USERNAME=$(whoami)

# Check if the user already exists in the file
if grep -q "=$USERNAME" "$FILE"; then
# Extract and display the assigned display number for the user
    DISPLAY_NUM=$(grep "=$USERNAME" "$FILE" | cut -d '=' -f 1)
    echo "User $USERNAME already exists with display number $DISPLAY_NUM, executing default shell..." >> "$LOG_FILE"
    echo "User $USERNAME already exists with display number $DISPLAY_NUM"

     # Start the VNC server service for the user
    sudo systemctl start vncserver@${DISPLAY_NUM}
    echo "Started VNC server for display number :$DISPLAY_NUM" >> "$LOG_FILE"
    echo "Started VNC server for display number :$DISPLAY_NUM"

    exec $SHELL

fi

# Find the last assigned number (if any)
if [ -f "$FILE" ]; then
    LAST_NUM=$(grep -oP "^:\d+" "$FILE" | sed 's/^://' | sort -n | tail -1)
else
    LAST_NUM=0
fi

# Increment the number
NEW_NUM=$((LAST_NUM + 1))

# Append the new entry
echo ":$NEW_NUM=$USERNAME" >> "$FILE"
echo "Entry added: :$NEW_NUM=$USERNAME" >> "$LOG_FILE"

echo "Assigned display number for user $USERNAME is :$NEW_NUM"

# Start the VNC server service for the new user
sudo systemctl start vncserver@${NEW_NUM}
echo "Started VNC server for display number :$NEW_NUM" >> "$LOG_FILE"
echo "Started VNC server for display number :$NEW_NUM"




-------------------------------------------

# FIRST LOGIN USER VNC PROFILE
# vncserver things
DIR_NAME="$HOME/.vnc"

# Check if the directory already exists
if [ ! -d "$DIR_NAME" ]; then
    mkdir "$DIR_NAME"
    echo "Directory '$DIR_NAME' created successfully."
else
    echo "Directory '$DIR_NAME' already exists."
fi

# Adding VNC config
cat > $HOME/.vnc/config << EOF
geometry=1920x1080
depth=32
EOF

chmod 644 $HOME/.vnc/config

# Adding xstartup file
cat > $HOME/.vnc/xstartup << EOF
#!/bin/bash
# Start the desktop environment
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
export XDG_SESSION_TYPE=x11


# Uncomment the following lines to start Xfce
startxfce4 &

# If no desktop environment is configured, fall back to xterm
[ -x /usr/bin/xterm ] && exec /usr/bin/xterm &
EOF

chmod +x $HOME/.vnc/xstartup

vncserver -rfbauth /usr/vnc/passwd  -xstartup /usr/vnc/xstartup :1 > /dev/null 2>&1

 


 ##################################################


 DIR_NAME="$HOME/.vnc"
USERNAME=$(whoami)
MAX_SESSIONS=4
# Check if the directory already exists
if [ ! -d "$DIR_NAME" ]; then
    mkdir "$DIR_NAME"
    echo "Directory '$DIR_NAME' created successfully."
else
    echo "Directory '$DIR_NAME' already exists."
fi > /dev/null 2>&1


# Adding VNC config
cat > $HOME/.vnc/config << EOF
geometry=1920x1080
depth=16
dpi=96
EOF

chmod 644 $HOME/.vnc/config

existing_session=$(pgrep -a Xvnc | grep "$USERNAME" | grep -oP ':\K[0-9]+' | head -n1)

if [ -n "$existing_session" ]; then
    echo "User $USERNAME already has a VNC session running on Port : 590$existing_session"
else
    for i in $(seq 1 $MAX_SESSIONS); do
        if ! pgrep -f "Xvnc.*:$i" > /dev/null; then
#            echo "Starting VNC server on display : 590$i"
            # Use setsid to start the VNC server
            setsid vncserver -rfbauth /usr/vnc/passwd -xstartup /usr/vnc/xstartup :$i > /dev/null 2>&1 &
            if [ $? -eq 0 ]; then
                echo "VNC server started on Port : 590$i"
            else
                echo "Failed to start VNC server on Port : 590$i"
            fi
            break
        fi
    done
fi
