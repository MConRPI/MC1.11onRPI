RED=`tput setaf 1`
GREEN=`tput setaf 2`
YELLOW=`tput setaf 3`
NC=`tput sgr0`
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if grep -Fxq "dtoverlay=vc4-kms-v3d" /boot/config.txt
then
echo "[${GREEN} ok ${NC}] Experimental GL driver is enabled"
else
echo "[${RED}FAIL${NC}] You must enable experimental GL driver, do it in raspi-config under advanced options. Choose full KMS (first option)"
fi
echo "[${YELLOW}info${NC}] Installing dependencies"

sudo apt update
sudo apt -y upgrade
sudo apt -y install xcompmgr libgl1-mesa-dri libalut0 libalut-dev mesa-utils

if [ -d ~/Minecraft ]
then
    echo "[${RED}FAIL${NC}] Minecraft directory already exists"
    exit 1
fi

if [ -d ~/.minecraft ]
then
    echo "[${RED}FAIL${NC}] .minecraft directory already exists"
    exit 1
fi

echo "[${YELLOW}info${NC}] Copying Minecraft launcher directory"
cp -r Minecraft ~

echo "[${YELLOW}info${NC}] Setting privileges for run script"
chmod +x ~/Minecraft/run.sh

echo "[${YELLOW}info${NC}] Copying .minecraft directory, this can take a while"
cp -r .minecraft ~

echo "[${GREEN} ok ${NC}] Installation done, set your credentials in run.sh under Minecraft directory and do ./run.sh in it"
