#!/bin/bash

red="tput setaf 1"
green="tput setaf 2"
reset="tput sgr0"

currentDir=${PWD##*/} 

hard="$($green)Performing hard reset$($reset)"
checkout="$($green)Checkout $1$($reset)"

# checkout root project
echo -e "Checking out $($red)APP $($reset)"
echo -e "$hard"
git reset --hard
echo -e "$checkout"
git checkout $1
echo -e "\n"

# checkout appcore
echo -e "Checking out $($red)APPCORE $($reset)"
cd appcore
echo -e "$hard"
git reset --hard
echo -e "$checkout"
git checkout $1
echo -e "\n"
cd ..

# checkout banksmartCore
echo -e "Checking out $($red)BANKSMARTCORE $($reset)"
cd ../BanksmartCore
echo -e "$hard"
git reset --hard
echo -e "$checkout"
git checkout $1
echo -e ""
cd ..
cd $currentDir

# initiate pod install
echo -e "Initiating $($titleColor)POD INSTALL$($resetColor)"
pod install
