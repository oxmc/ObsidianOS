#!/bin/bash

#Functions
function error {
  echo -e "\e[91m$1\e[39m"
  if [ "$2" == "exit" ]; then
    exit 1
  else
    fwe="1"
    ers+="\n$1"
  fi
}

function warning {
  echo -e "\e[91m$2\e[39m"
  sleep "$1"
}

#variables
TARGETARCH="armhf"
ARCH="$(dpkg --print-architecture)"
fwe="0"
ers=""

#Main
clear
echo "Checking if device is compatible..."
if [ "$ARCH" == "$TARGETARCH" ]; then
  echo -e "\e[32mYour device is compatible.\e[39m"
  if grep -q "https://oxmc.github.io/files/rpi/apps/imager-rpi/debian" "/etc/apt/sources.list"; then
    error "ObsidianOS-repo has already been added to your device."
  else
    echo "Adding the ObsidianOS-repo to your device..."
    echo "Creating backup of /etc/apt/sources.list"
    sudo cp -r /etc/apt/sources.list /home/apt.list || error "Unable to cp /etc/apt/sources.list to /home/apt.list!"
    echo "Adding repo to apt..."
    echo "deb [trusted=yes] https://oxmc.github.io/files/rpi/apps/imager-rpi/debian ./" | sudo tee -a /etc/apt/sources.list > /dev/null
    echo "Done!"
    echo "Updating apt sources..."
    sudo apt-get update || error "Unable to run sudo apt-get update!"
    echo "ObsidianOS-repo has been added to your device!"
    echo "To install the ObsidianOS-Imager run 'sudo apt-get install ob-imager'"
  fi
else
  echo "Your device is not compatible."
  error "Unable to continue as device is $ARCH not $TARGETARCH."
fi

#Inform user that the install has finished
#Check if finished with errors
if [ "${fwe}" == "1" ]; then
  echo -e "\n"
  echo -e "This script finished with errors, Here are the errors: \n\e[91m$ers\e[39m"
  exit 1
elif [ "${fwe}" == "0" ]; then
  echo -e "\e[32mFinished!\e[39m"
  exit 0
fi
