#!/bin/bash

titleColor="tput setaf 1"
subTitleColor="tput setaf 2"
resetColor="tput sgr0"

# outputs for commands
commit="\n$($subTitleColor)Commiting changes to versions.gradle$($resetColor)"
cleanUp="\n$($subTitleColor)Removing changed_modules.txt$($resetColor)"

# update versions in features
echo -e "Update version in $($titleColor)FEATURES $($resetColor)"
cd features
branch=$(git symbolic-ref --short -q HEAD)
echo -e "$($subTitleColor)Updating versions in $branch$($resetColor)"
kotlin -cp $1 VersionsKt appcore
echo -e "$commit"
git add versions.gradle
git commit --file=changed_modules.txt
echo -e "$cleanUp"
rm changed_modules.txt
echo -e "\n$($subTitleColor)Force pushing changes to $branch$($resetColor)"
git push --force-with-lease origin $branch
echo -e "\n"
cd ..

# update versions in libraries
echo -e "Update version in $($titleColor)LIBRARIES $($resetColor)"
cd libraries
branch=$(git symbolic-ref --short -q HEAD)
echo -e "$($subTitleColor)Updating versions in $branch$($resetColor)"
kotlin -cp $1 VersionsKt
echo -e "$commit"
git add versions.gradle
git commit --file=changed_modules.txt
echo -e "$cleanUp"
rm changed_modules.txt
echo -e "\n$($subTitleColor)Force pushing changes to $branch$($resetColor)"
git push --force-with-lease origin $branch
echo -e "\n"
cd ..

# update appcore versions in app layer
echo -e "Update appcore version in $($titleColor)APP $($resetColor)"
appcoreVer=$(awk '/versions.appcore/ {print $NF;exit}' features/versions.gradle)
echo -e "\n$($subTitleColor)Update appcore version to $appcoreVer$($resetColor)"
awk -i inplace -v v="$appcoreVer" '/versions.appcore/ {getline x;sub($NF, v);print $0 RS x;next}1' versions.gradle
pushBranch=$(git symbolic-ref --short -q HEAD)
echo -e "$commit"
git add .
git commit -m "appcore ----> $appcoreVer"
echo -e "\n$($subTitleColor)Force pushing changes to $pushBranch$($resetColor)"
git push --force-with-lease origin $pushBranch

