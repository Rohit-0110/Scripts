#!/bin/bash

install_dependecies() {
    echo "Installing pyenv dependencies..."
    sudo apt update
    sudo apt install -qq -y git curl make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev
    echo "Dependencies installed."
}


install_pyenv() {
    if command -v pyenv 1>/dev/null 2>&1; then
        echo "pyenv is already installed. Skipping installation."
    else
        echo "Installing pyenv..."
        # Clone the pyenv repository
        sudo git clone https://github.com/pyenv/pyenv.git /usr/local/pyenv
        # Update the profile
        sudo echo 'export PATH="/usr/local/pyenv/bin:$PATH"' >> ~/.bashrc
        sudo echo 'eval "$(pyenv init -)"' >> ~/.bashrc
        source ~/.bashrc
        if command -v pyenv 1>/dev/null 2>&1; then
            eval "$(pyenv init --path)"
        fi
            echo "pyenv installed."
    fi
}

# main script execution
install_dependecies
install_pyenv

install_python_version() {
    read -p "Enter the Python version to install (e.g., 3.8): " python_version
    sudo /usr/local/pyenv/bin/pyenv install "$python_version"
    sudo /usr/local/pyenv/bin/pyenv global "$python_version"
    echo "Python ${python_version} installed and set as global version."
}

# Ask user if they want to install a Python version
read -p "Do you want to install a specific Python version now? (y/n): " install_now
if [[ "$install_now" =~ ^[Yy]$ ]]; then
    install_python_version
fi

echo "pyenv setup complete. Please restart your terminal or run 'source ~/.bashrc' to start using pyenv."