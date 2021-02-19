#!/bin/bash

titleColor="tput setaf 1"
subTitleColor="tput setaf 2"
resetColor="tput sgr0"
# current branch for app layer
branch=$(git symbolic-ref --short -q HEAD)

# outputs for commands
switch="$($subTitleColor)Switch to develop$($resetColor)"
sync="\n$($subTitleColor)Sync develop$($resetColor)"
create="\n$($subTitleColor)Create branch $1$($resetColor)"
rebase="\n$($subTitleColor)Rebase with develop$($resetColor)"

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

# checkout features
echo -e "Finalizing chnages to $($titleColor)FEATURES $($resetColor)"
cd features
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

# checkout libraries
echo -e "Finalizing changes to $($titleColor)LIBRARIES $($resetColor)"
cd libraries
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
