#!/bin/sh
set -eu

TMP_WORK_DIR="tmp-$GITHUB_SHA"

WIKI_REPO_DIR="wiki-repo"
WIKI_UPDATE_DIR="wiki-update"

echo Create working directory
mkdir -p -- $TMP_WORK_DIR

echo Going to $TMP_WORK_DIR
cd $TMP_WORK_DIR

echo Creating wiki folders
mkdir -p -- $WIKI_REPO_DIR
mkdir -p -- $WIKI_UPDATE_DIR

echo Cloning wiki
git clone https://$GITHUB_ACTOR:$GITHUB_TOKEN@github.com/$GITHUB_REPOSITORY.wiki.git $WIKI_REPO_DIR

echo Create updated wiki
echo "HELLO WORLD THIS IS MY FILE" > $WIKI_UPDATE_DIR/helloworld.md

echo "Copying edited wiki"
cp -R "$WIKI_REPO_DIR/.git" "$WIKI_UPDATE_DIR/"

echo Go into the repo
cd $WIKI_UPDATE_DIR
pwd
ls -a

echo Prepare commit
#Get commit details
author=`git log -1 --format="%an"`
email=`git log -1 --format="%ae"`
message=`git log -1 --format="%s"`

git config --local user.email "$email"
git config --local user.name "$author" 
git add .

echo "Pushing changes to wiki"
git commit -m "$message" && git push "https://$GITHUB_ACTOR:$GITHUB_TOKEN@github.com/$GITHUB_REPOSITORY.wiki.git"