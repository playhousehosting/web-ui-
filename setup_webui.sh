#!/bin/bash

# Define variables
REPO_URL="https://github.com/browser-use/web-ui.git"
PROJECT_DIR="web-ui"
PYTHON_VERSION="3.11"
VENV_DIR=".venv"

# Function to print messages
print_message() {
    echo "================================================="
    echo $1
    echo "================================================="
}

# Function to install Python 3.11
install_python() {
    print_message "Installing Python 3.11..."
    sudo apt update
    sudo apt install -y software-properties-common
    sudo add-apt-repository ppa:deadsnakes/ppa
    sudo apt install -y python$PYTHON_VERSION python$PYTHON_VERSION-venv
}

# Check if Python 3.11 is installed
if ! command -v python$PYTHON_VERSION &> /dev/null; then
    install_python
fi

# Step 1: Clone the Repository
print_message "Cloning the repository..."
git clone $REPO_URL
cd $PROJECT_DIR

# Step 2: Set Up Python Environment
print_message "Setting up Python environment..."
python$PYTHON_VERSION -m venv $VENV_DIR
source $VENV_DIR/bin/activate

# Step 3: Install Dependencies
print_message "Installing dependencies..."
pip install -r requirements.txt
pip install playwright
playwright install

# Step 4: Configure Environment
print_message "Configuring environment..."
cp .env.example .env

# Prompt user for API keys and other settings
read -p "Enter your OPENAI_API_KEY: " OPENAI_API_KEY
read -p "Enter your ANTHROPIC_API_KEY: " ANTHROPIC_API_KEY
read -p "Enter your GOOGLE_API_KEY: " GOOGLE_API_KEY
read -p "Enter your VNC_PASSWORD (default is 'vncpassword'): " VNC_PASSWORD

# Update .env file with user inputs
sed -i "s|OPENAI_API_KEY=your_key_here|OPENAI_API_KEY=$OPENAI_API_KEY|" .env
sed -i "s|ANTHROPIC_API_KEY=your_key_here|ANTHROPIC_API_KEY=$ANTHROPIC_API_KEY|" .env
sed -i "s|GOOGLE_API_KEY=your_key_here|GOOGLE_API_KEY=$GOOGLE_API_KEY|" .env
sed -i "s|VNC_PASSWORD=your_vnc_password|VNC_PASSWORD=$VNC_PASSWORD|" .env

# Step 5: Run the Application
print_message "Running the application..."
python webui.py --ip 127.0.0.1 --port 7788

# Inform the user
print_message "Setup complete! Access the WebUI at http://127.0.0.1:7788"
print_message "Access the VNC Viewer at http://localhost:6080/vnc.html"
