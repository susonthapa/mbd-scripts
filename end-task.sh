#!/bin/bash

titleColor="tput setaf 1"
subTitleColor="tput setaf 2"
resetColor="tput sgr0"
# current branch for app layer
branch=$(git symbolic-ref --short -q HEAD)
currentDir=${PWD##*/} 

# outputs for commands
switch="$($subTitleColor)Switch to develop branch$($resetColor)"
sync="\n$($subTitleColor)Sync develop branch$($resetColor)"
create="\n$($subTitleColor)Create branch $1$($resetColor)"
rebase="\n$($subTitleColor)Rebase with develop branch$($resetColor)"

# checkout root project
echo -e "Finalizing changes to $($titleColor)APP $($resetColor)"
echo -e "$switch"
git checkout develop
echo -e "$sync"
git pull origin develop
echo -e "\n$($subTitleColor)Switch to $branch$($resetColor)"
git checkout $branch
echo -e "$rebase"
git rebase develop
echo -e "\n"

# checkout appcore
echo -e "Finalizing changes to $($titleColor)APPCORE $($resetColor)"
cd appcore
branch=$(git symbolic-ref --short -q HEAD)
echo -e "$switch"
git checkout develop
echo -e "$sync"
git pull origin develop
echo -e "\n$($subTitleColor)Switch to $branch$($resetColor)"
git checkout $branch
echo -e "$rebase"
git rebase develop
echo -e "\n"
cd ..

# checkout banksmartCore
echo -e "Finalizing changes to $($titleColor)BANKSMARTCORE $($resetColor)"
cd ../BanksmartCore
branch=$(git symbolic-ref --short -q HEAD)
echo -e "$switch"
git checkout develop
echo -e "$sync"
git pull origin develop
echo -e "\n$($subTitleColor)Switch to $branch$($resetColor)"
git checkout $branch
echo -e "$rebase"
git rebase develop
echo -e ""
cd ..
cd $currentDir

# initiate pod install
echo -e "Initiating $($titleColor)POD INSTALL$($resetColor)"
pod install
