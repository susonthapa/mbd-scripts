#!/bin/bash

titleColor="tput setaf 1"
subTitleColor="tput setaf 2"
resetColor="tput sgr0"

# current branch for app layer
branch=$(git symbolic-ref --short -q HEAD)

# outputs for commands
update="$($subTitleColor)Updating versions in $branch$($resetColor)"
commit="\n$($subTitleColor)Commiting changes to versions.gradle$($resetColor)"
cleanUp="\n$($subTitleColor)Removing changed_modules.txt$($resetColor)"
push="\n$($subTitleColor)Force pushing changes to $branch$($resetColor)"
switchTarget="\n$($subTitleColor)Switch to $branch$($resetColor)"

# update versions in features
echo -e "Update version in $($titleColor)FEATURES $($resetColor)"
cd features
branch=$(git symbolic-ref --short -q HEAD)
echo -e "$update"
kotlinc -script versions.kts appcore
echo -e "$commit"
git add versions.gradle
git commit --file=changed_modules.txt
echo -e "$cleanUp"
rm changed_modules.txt
echo -e "$push"
git push --force-with-lease origin $branch
echo -e "\n"
cd ..

# update versions in libraries
echo -e "Update version in $($titleColor)LIBRARIES $($resetColor)"
cd libraries
branch=$(git symbolic-ref --short -q HEAD)
echo -e "$update"
kotlinc -script versions.kts
echo -e "$commit"
git add versions.gradle
git commit --file=changed_modules.txt
echo -e "$cleanUp"
rm changed_modules.txt
echo -e "$push"
git push --force-with-lease origin $branch
echo -e "\n"
cd ..

# sync latest appcore versions in app layer

