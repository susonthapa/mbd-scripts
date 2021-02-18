#!/bin/bash

red="tput setaf 1"
green="tput setaf 2"
reset="tput sgr0"

# outputs for commands
switch="$($green)Switch to develop$($reset)"
sync="\n$($green)Sync develop$($reset)"
create="\n$($green)Create branch$($reset)"

# checkout root project
echo -e "Checking out $($red)APP $($reset)at $1"
echo -e "$switch"
git checkout develop
echo -e "$sync"
git pull origin develop
echo -e "$create"
git checkout -b $1
echo -e "\n"

# checkout features
echo -e "Checking out $($red)FEATURES $($reset)at $1"
cd features
echo -e "$switch"
git checkout develop
echo -e "$sync"
git pull origin develop
echo -e "$create"
git checkout -b $1
echo -e "\n"
cd ..

# checkout libraries
echo -e "Checking out $($red)LIBRARIES $($reset)at $1"
cd libraries
echo -e "$switch"
git checkout develop
echo -e "$sync"
git pull origin develop
echo -e "$create"
git checkout -b $1
echo -e ""
cd ..
