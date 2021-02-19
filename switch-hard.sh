#!/bin/bash

red="tput setaf 1"
green="tput setaf 2"
reset="tput sgr0"

hard="$($green)Performing hard reset$($reset)"
checkout="$($green)Checkout $1$($reset)"

# checkout root project
echo -e "Checking out $($red)APP $($reset)"
echo -e "$hard"
git reset --hard
echo -e "$checkout"
git checkout $1
echo -e "\n"

# checkout features
echo -e "Checking out $($red)FEATURES $($reset)"
cd features
echo -e "$hard"
git reset --hard
echo -e "$checkout"
git checkout $1
echo -e "\n"
cd ..

# checkout libraries
echo -e "Checking out $($red)LIBRARIES $($reset)"
cd libraries
echo -e "$hard"
git reset --hard
echo -e "$checkout"
git checkout $1
echo -e ""
cd ..
