#!/bin/bash

PACKAGE_NAME=${1}

# Check the operating system
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
else
    echo "Operating system not supported!"
    exit 1
fi

check_package_name() {
    if [[ -z "${PACKAGE_NAME}" ]]; then
        echo "Error: Package name is not specified"
        exit 1
    fi
}

# Function to install package on ubuntu
install_on_ubuntu() {
    check_package_name
    if dpkg -l | grep -qw "$PACKAGE_NAME"; then
        echo "$PACKAGE_NAME is already installed."
    else
        echo "$PACKAGE_NAME is not installed. Installing on Ubuntu..."
        sudo apt update
        sudo apt install -y "$PACKAGE_NAME"

        # Verify installation
        if dpkg -l | grep -qw "$PACKAGE_NAME"; then
            echo "$PACKAGE_NAME has been installed successfully on Ubuntu."
        else
            echo "Failed to install $PACKAGE_NAME on Ubuntu."
        fi
    fi
}

# Function to install package on centos
install_on_centos() {
    check_package_name
    if rpm -qa | grep -qw "$PACKAGE_NAME"; then
        echo "$PACKAGE_NAME is already installed."
    else
        echo "$PACKAGE_NAME is not installed. Installing on CentOS..."
        sudo yum install -y "$PACKAGE_NAME"

        # Verify installation
        if rpm -qa | grep -qw "$PACKAGE_NAME"; then
            echo "$PACKAGE_NAME has been installed successfully on CentOS."
        else
            echo "Failed to install $PACKAGE_NAME on CentOS."
        fi
    fi
}

case "$OS" in
ubuntu)
    install_on_ubuntu
    ;;
centos)
    install_on_centos
    ;;
*)
    echo "Unsupported operating system: $OS"
    exit 1
    ;;
esac
