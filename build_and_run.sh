#!/bin/bash
set -e
echo "NOTICE: If you install Torsocks run the program again because 'apt install' will make this program stop"
echo "Notice to Prounce: use your other config.ini because this doesnt come with one" 
echo ""
echo "Building the Go project..."

# Make sure modules are tidy
go mod tidy

# Build the executable
go build -o minestalker

if [ $? -ne 0 ]; then
    echo "Build failed."
    exit 1
fi

# Check if build succeeded
echo "Build succeeded."

read -r -p "Is tor installed? [Y/n] " answer
if [[ ! "$answer" =~ ^[Yy]$ ]]; then
    read -r -p "Install it now? [Y/n] " install_answer
    if [[ "$install_answer" =~ ^[Yy]$ ]]; then
        sudo -v                          # prime sudo credentials up front
        sudo apt update
        sudo apt install -y tor
    else
        echo "tor is required. Exiting."
        exit 1
    fi
fi

sudo -v
sudo systemctl enable --now tor

echo "Running executable (Tor daemon is up; minestalker routes only its scrape requests through it)..."
./minestalker

kill "$SERVER_PID" 2>/dev/null
