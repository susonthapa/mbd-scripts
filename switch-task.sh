#!/bin/bash

red="tput setaf 1"
green="tput setaf 2"
reset="tput sgr0"

currentDir=${PWD##*/} 

# checkout root project
echo -e "Checking out $($red)APP $($reset)at $1"
git checkout $1
echo -e "\n"

# checkout appcore
echo -e "Checking out $($red)APPCORE $($reset)at $1"
cd appcore
git checkout $1
echo -e "\n"
cd ..

# checkout banksmartCore
echo -e "Checking out $($red)BANKSMARTCORE $($reset)at $1"
cd ../BanksmartCore
git checkout $1
echo -e ""
cd ..
cd $currentDir

# initiate pod install
echo -e "Initiating $($titleColor)POD INSTALL$($resetColor)"
pod install
