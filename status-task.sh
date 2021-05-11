#!/bin/bash

red="tput setaf 1"
green="tput setaf 2"
reset="tput sgr0"

currentDir=${PWD##*/} 

# status root project
echo -e "Status of $($red)APP $($reset)"
git status
echo -e "\n"

# status appcore
echo -e "Status of $($red)APPCORE $($reset)"
cd appcore
git status
echo -e "\n"
cd ..

# status banksmartCore
echo -e "Status of $($red)BANKSMARTCORE $($reset)"
cd ../BanksmartCore
git status
echo -e ""
cd ..
cd $currentDir
