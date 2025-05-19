#!/bin/bash

FILE_COMSOL="$HOME/.local/share/applications/comsol.desktop"
FILE_LUMERICAL="$HOME/.local/share/applications/lumerical.desktop"

# Check if file exists
if [ -e "$FILE_COMSOL" ]; then
    exec $SHELL
else
    mkdir -p $HOME/.local/share/applications
    cat > $HOME/.local/share/applications/comsol.desktop << EOF
    [Desktop Entry]
    Version=1.0
    Type=Application
    Name=Comsol 6.2
    Exec=/efs/cad/tools/comsol/comsol62/multiphysics/bin/comsol
    #Icon=/opt/lumerical/202X/resources/icons/lumerical.png
    Terminal=false
    Categories=Science;Engineering;    
EOF
fi

if [ -e "$FILE_LUMERICAL" ]; then
    exec $SHELL
else
    mkdir -p $HOME/.local/share/applications
    cat > $HOME/.local/share/applications/lumerical.desktop << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Lumerical Suite
Exec=/opt/lumerical/v242/bin/device
#Icon=/opt/lumerical/202X/resources/icons/lumerical.png
Terminal=false
Categories=Science;Engineering;
EOF
fi


mkdir -p $HOME/.local/share/applications



cat > $HOME/.local/share/applications/lumerical.desktop << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Lumerical Suite
Exec=/opt/lumerical/v242/bin/device
#Icon=/opt/lumerical/202X/resources/icons/lumerical.png
Terminal=false
Categories=Science;Engineering;
EOF

chmod 755 $HOME/.local/share/applications/comsol.desktop
chmod 755 $HOME/.local/share/applications/lumerical.desktop

