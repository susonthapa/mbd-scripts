#!/bin/bash

red="tput setaf 1"
green="tput setaf 2"
reset="tput sgr0"

# checkout root project
echo -e "Checking out $($red)APP $($reset)at $1"
git checkout $1
echo -e "\n"

# checkout features
echo -e "Checking out $($red)FEATURES $($reset)at $1"
cd features
git checkout $1
echo -e "\n"
cd ..

# checkout libraries
echo -e "Checking out $($red)LIBRARIES $($reset)at $1"
cd libraries
git checkout $1
echo -e ""
cd ..
