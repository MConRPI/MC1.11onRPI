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
sudo apt -y install xcompmgr libgl1-mesa-dri
sudo apt -y install libalut0 libalut-dev
sudo apt -y install mesa-utils

if [ -d ~/Minecraft ]
then
    "[${RED}FAIL${NC}] Minecraft directory already exists"
    exit 1
fi

echo "[${YELLOW}info${NC}] Creating directory structure"
mkdir ~/Minecraft
mkdir ~/Minecraft/Natives
mkdir ~/Minecraft/Libraries

echo "[${YELLOW}info${NC}] Downloading Minecraft launcher"
cd ~/Minecraft && wget "https://s3.amazonaws.com/Minecraft.Download/launcher/Minecraft.jar"

echo "[${YELLOW}info${NC}] Downloading Optifine installer"
cd /tmp && wget "http://optifine.net/downloadx?f=OptiFine_1.11.2_HD_U_B7.jar&x=5bfdf9ba2e691d97b52877dcbb79ad87 -O Optifine.jar"

echo "[${YELLOW}info${NC}] Downloading ASM"
cd ~/Minecraft/Libraries && wget "http://download.forge.ow2.org/asm/asm-5.2-bin.zip"
cd ~/Minecraft/Libraries && unzip asm-5.2-bin.zip

echo "[${YELLOW}info${NC}] Downloading custom precompiled minecraft natives"
cd ~/Minecraft/Natives && wget "https://www.dropbox.com/s/4oxcvz3ky7a3x6f/liblwjgl.so" && wget "https://www.dropbox.com/s/m0r8e01jg2og36z/libopenal.so"

echo "[${YELLOW}info${NC}] Launching Minecraft launcher..."
echo "[${YELLOW}info${NC}] LOGIN TO YOUR PROFILE AND SELECT VERSION 1.11.2. PRESS PLAY, LAUNCHER WILL CRASH. CLOSE LAUNCHER WINDOW AFTER CRASH!"
cd ~/Minecraft && java -jar Minecraft.jar

echo "[${YELLOW}info${NC}] Replacing LWJGL"
cd /home/pi/.minecraft/libraries/org/lwjgl/lwjgl/lwjgl/2.9.4-nightly-20150209 && rm lwjgl-2.9.4-nightly-20150209.jar && wget https://www.dropbox.com/s/mj15sz3bub4dmr6/lwjgl-2.9.4-nightly-20150209.jar

echo "[${YELLOW}info${NC}] Launching Optifine installer ..."
echo "[${YELLOW}info${NC}] CLICK ON INSTALL BUTTON, WAIT AND CLOSE INSTALLATOR"
cd /tmp && java -jar Optifine.jar

echo "[${YELLOW}info${NC}] Launching Minecraft launcher..."
echo "[${YELLOW}info${NC}] LOGIN TO YOUR PROFILE AND SELECT OPTIFINE 1.11.2 AS VERSION. PRESS PLAY, LAUNCHER WILL CRASH. CLOSE LAUNCHER WINDOW AFTER CRASH!"
cd ~/Minecraft && java -jar Minecraft.jar

echo "[${YELLOW}info${NC}] Copying run script"
cp "$DIR/run.sh" ~/Minecraft/
cd ~/Minecraft && chmod +x run.sh

echo "[${GREEN} ok ${NC}] Installation done, set your credentials in run.sh under Minecraft directory and do ./run.sh in it"
