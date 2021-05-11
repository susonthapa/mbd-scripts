#!/bin/bash

red="tput setaf 1"
green="tput setaf 2"
reset="tput sgr0"

# status root project
echo -e "Status of $($red)APP $($reset)"
git status
echo -e "\n"

# status features
echo -e "Status of $($red)FEATURES $($reset)"
cd features
git status
echo -e "\n"
cd ..

# status libraries
echo -e "Status of $($red)LIBRARIES $($reset)"
cd libraries
git status
echo -e ""
cd ..
