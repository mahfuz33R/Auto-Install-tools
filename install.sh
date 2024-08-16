#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to copy files to /usr/local/bin and /usr/bin if they do not exist
copy_if_not_exist() {
    for file in "$1"/*; do
        base_file=$(basename "$file")
        if [ ! -f "/usr/local/bin/$base_file" ]; then
            echo -e "${YELLOW}Copying $base_file to /usr/local/bin...${NC}"
            echo "$sudopass" | sudo -S cp "$file" /usr/local/bin/
        else
            echo -e "${GREEN}$base_file already exists in /usr/local/bin.${NC}"
        fi

        if [ ! -f "/usr/bin/$base_file" ]; then
            echo -e "${YELLOW}Copying $base_file to /usr/bin...${NC}"
            echo "$sudopass" | sudo -S cp "$file" /usr/bin/
        else
            echo -e "${GREEN}$base_file already exists in /usr/bin.${NC}"
        fi
    done
}

# Define colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print banner
print_banner() {
    clear
    figlet "Fresh In\$tall"
    printf "%80s\n" " ---MAHFUZ aka H!s3nb3erg"
}

# Prompt for sudo password
read -sp "Enter your sudo password: " sudopass
echo

# Install figlet if not already installed
if ! command_exists figlet; then
    echo "$sudopass" | sudo -S apt-get install -y figlet > /dev/null 2>&1
fi

# Print the banner
print_banner

# Check if tools directory exists, if not, create it
if [ ! -d ~/tools ]; then
    echo -e "${YELLOW}Creating tools directory...${NC}"
    mkdir -p ~/tools
else
    echo -e "${GREEN}tools directory already exists.${NC}"
fi
cd ~/tools || exit

# Update the system
echo -e "${YELLOW}Updating the system...${NC}"
echo "$sudopass" | sudo -S apt update -y && sudo apt full-upgrade -y
sudo updatedb

# Remove old packages
echo -e "${YELLOW}Removing old packages...${NC}"
echo "$sudopass" | sudo -S apt autoremove -y

# Print the banner again after clearing the screen
print_banner

# List of tools to be installed via apt
apt_tools=(
    "sublist3r"
    "python3-pip"
    "seclists"
    "curl"
    "dnsrecon"
    "enum4linux"
    "feroxbuster"
    "gobuster"
    "impacket-scripts"
    "nbtscan"
    "nikto"
    "nmap"
    "onesixtyone"
    "oscanner"
    "redis-tools"
    "smbclient"
    "smbmap"
    "snmp"
    "sslscan"
    "sipvicious"
    "tnscmd10g"
    "whatweb"
    "wkhtmltopdf"
    "ffuf"
    "python3-impacket"
    "crackmapexec"
    "flameshot"
    "chromium"
    "xsser"
    "subfinder"
    "amass"
    "massdns"
    "tmux"
    "arjun"
)

# Install each tool via apt if not already installed
for tool in "${apt_tools[@]}"; do
    echo -e "\n\n${YELLOW}Checking $tool...${NC}"
    if command_exists "$tool"; then
        echo -e "${GREEN}$tool is already installed.${NC}"
    else
        echo -e "${YELLOW}Installing $tool...${NC}"
        echo "$sudopass" | sudo -S apt install -y "$tool"
    fi
done

# Install Python packages via pip
pip_packages=(
    "xnLinkFinder"
)

for package in "${pip_packages[@]}"; do
    echo -e "\n\n${YELLOW}Checking $package...${NC}"
    if python3 -m pip show "$package" >/dev/null 2>&1; then
        echo -e "${GREEN}$package is already installed.${NC}"
    else
        echo -e "${YELLOW}Installing $package...${NC}"
        python3 -m pip install "$package"
    fi
done

# List of tools to be installed from GitHub
github_tools=(
    "https://github.com/aboul3la/Sublist3r.git"
    "https://github.com/21y4d/nmapAutomator.git"
    "https://github.com/s0md3v/XSStrike.git"
    "https://github.com/TheRook/subbrute.git"
    "https://github.com/faiyazahmad07/GET-AUTOMATOR.git"
    "https://github.com/s0md3v/Photon.git"
    "https://github.com/PushkraJ99/ParamSpider.git"
    # Add more GitHub repository URLs here
)

# Clone and install each GitHub tool if not already cloned
for repo in "${github_tools[@]}"; do
    repo_name=$(basename "$repo" .git)
    echo -e "\n\n${YELLOW}Checking $repo_name...${NC}"
    if [ -d "$repo_name" ]; then
        echo -e "${GREEN}$repo_name is already cloned.${NC}"
    else
        echo -e "${YELLOW}Cloning $repo_name...${NC}"
        git clone "$repo"
        echo -e "${YELLOW}Installing $repo_name...${NC}"
        cd "$repo_name" || exit
        if [ "$repo_name" = "Photon" ]; then
            echo -e "${YELLOW}Installing requirements for Photon...${NC}"
            pip3 install -r requirements.txt
        elif [ "$repo_name" = "ParamSpider" ]; then
            echo -e "${YELLOW}Installing ParamSpider...${NC}"
            pip install .
        fi
        cd ..
    fi
done

# Install AutoRecon from GitHub using pip
echo -e "\n\n${YELLOW}Checking AutoRecon...${NC}"
if command_exists autorecon; then
    echo -e "${GREEN}AutoRecon is already installed.${NC}"
else
    echo -e "${YELLOW}Installing AutoRecon...${NC}"
    python3 -m pip install git+https://github.com/Tib3rius/AutoRecon.git
fi

# Check if Go is installed
echo -e "\n\n${YELLOW}Checking Go...${NC}"
if command_exists go; then
    echo -e "${GREEN}Go is already installed.${NC}"
else
    echo -e "${YELLOW}Installing Go...${NC}"
    echo "$sudopass" | sudo -S apt install -y golang
fi

# Check if Nuclei is installed
echo -e "\n\n${YELLOW}Checking Nuclei...${NC}"
if command_exists nuclei; then
    echo -e "${GREEN}Nuclei is already installed.${NC}"
else
    echo -e "${YELLOW}Installing Nuclei...${NC}"
    go install -v github.com.projectdiscovery/nuclei/v3/cmd/nuclei@latest
    cd ~/go/bin || exit
    copy_if_not_exist ~/go/bin
fi

# Check if httpx is installed
echo -e "\n\n${YELLOW}Checking httpx...${NC}"
if command_exists httpx; then
    echo -e "${GREEN}httpx is already installed.${NC}"
else
    echo -e "${YELLOW}Installing httpx...${NC}"
    go install -v github.com.projectdiscovery/httpx/cmd/httpx@latest
    cd ~/go/bin || exit

    if [ ! -f /usr/local/bin/httpx ]; then
        echo -e "${YELLOW}Moving httpx to /usr/local/bin...${NC}"
        echo "$sudopass" | sudo -S mv httpx /usr/local/bin/
    else
        echo -e "${GREEN}httpx already exists in /usr/local/bin.${NC}"
    fi

    if [ ! -f /usr/bin/httpx ]; then
        echo -e "${YELLOW}Moving httpx to /usr/bin...${NC}"
        echo "$sudopass" | sudo -S mv httpx /usr/bin/
    else
        echo -e "${GREEN}httpx already exists in /usr/bin.${NC}"
    fi
fi

# Check if dnsx is installed
echo -e "\n\n${YELLOW}Checking dnsx...${NC}"
if command_exists dnsx; then
    echo -e "${GREEN}dnsx is already installed.${NC}"
else
    echo -e "${YELLOW}Installing dnsx...${NC}"
    go install -v github.com/projectdiscovery/dnsx/cmd/dnsx@latest
    cd ~/go/bin || exit

    if [ ! -f /usr/local/bin/dnsx ]; then
        echo -e "${YELLOW}Moving dnsx to /usr/local/bin...${NC}"
        echo "$sudopass" | sudo -S mv dnsx /usr/local/bin/
    else
        echo -e "${GREEN}dnsx already exists in /usr/local/bin.${NC}"
    fi

    if [ ! -f /usr/bin/dnsx ]; then
        echo -e "${YELLOW}Moving dnsx to /usr/bin...${NC}"
        echo "$sudopass" | sudo -S mv dnsx /usr/bin/
    else
        echo -e "${GREEN}dnsx already exists in /usr/bin.${NC}"
    fi
fi

# Check if puredns is installed
echo -e "\n\n${YELLOW}Checking puredns...${NC}"
if command_exists puredns; then
    echo -e "${GREEN}puredns is already installed.${NC}"
else
    echo -e "${YELLOW}Installing puredns...${NC}"
    go install github.com/d3mondev/puredns/v2@latest
    cd ~/go/bin || exit

    if [ ! -f /usr/local/bin/puredns ]; then
        echo -e "${YELLOW}Moving puredns to /usr/local/bin...${NC}"
        echo "$sudopass" | sudo -S mv puredns /usr/local/bin/
    else
        echo -e "${GREEN}puredns already exists in /usr/local/bin.${NC}"
    fi

    if [ ! -f /usr/bin/puredns ]; then
        echo -e "${YELLOW}Moving puredns to /usr/bin...${NC}"
        echo "$sudopass" | sudo -S mv puredns /usr/bin/
    else
        echo -e "${GREEN}puredns already exists in /usr/bin.${NC}"
    fi
fi

# Check if aquatone is installed
echo -e "\n\n${YELLOW}Checking aquatone...${NC}"
if command_exists aquatone; then
    echo -e "${GREEN}aquatone is already installed.${NC}"
else
    echo -e "${YELLOW}Installing aquatone...${NC}"
    wget https://github.com/michenriksen/aquatone/releases/download/v1.7.0/aquatone_linux_amd64_1.7.0.zip
    unzip aquatone_linux_amd64_1.7.0.zip -d aquatone
    cd aquatone || exit

    # Check if aquatone already exists before copying
    if [ ! -f /usr/local/bin/aquatone ]; then
        echo -e "${YELLOW}Copying aquatone to /usr/local/bin...${NC}"
        echo "$sudopass" | sudo -S cp aquatone /usr/local/bin/
    else
        echo -e "${GREEN}aquatone already exists in /usr/local/bin.${NC}"
    fi

    if [ ! -f /usr/bin/aquatone ]; then
        echo -e "${YELLOW}Copying aquatone to /usr/bin...${NC}"
        echo "$sudopass" | sudo -S cp aquatone /usr/bin/
    else
        echo -e "${GREEN}aquatone already exists in /usr/bin.${NC}"
    fi

    # Remove the original directory and zip file
    cd ..
    rm -rd aquatone
    rm aquatone_linux_amd64_1.7.0.zip
fi

echo -e "${GREEN}All requested tools have been checked and installed if necessary.${NC}"
