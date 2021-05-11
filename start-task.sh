#!/bin/bash

red="tput setaf 1"
green="tput setaf 2"
reset="tput sgr0"

currentDir=${PWD##*/} 

# outputs for commands
switch="$($green)Switch to develop branch$($reset)"
sync="\n$($green)Sync develop branch$($reset)"
create="\n$($green)Create branch $1$($reset)"

# checkout root project
echo -e "Checking out $($red)APP $($reset)at $1"
echo -e "$switch"
git checkout develop
echo -e "$sync"
git pull origin develop
echo -e "$create"
git checkout -b $1
echo -e "\n"

# checkout appcore
echo -e "Checking out $($red)APPCORE $($reset)at $1"
cd appcore
echo -e "$switch"
git checkout develop
echo -e "$sync"
git pull origin develop
echo -e "$create"
git checkout -b $1
echo -e "\n"
cd ..

# checkout banksmartCore
echo -e "Checking out $($red)BANKSMARTCORE $($reset)at $1"
cd ../BanksmartCore
echo -e "$switch"
git checkout develop
echo -e "$sync"
git pull origin develop
echo -e "$create"
git checkout -b $1
echo -e "\n"
cd ..
cd $currentDir

# initiate pod install
echo -e "Initiating $($red)POD INSTALL$($reset)"
pod install
