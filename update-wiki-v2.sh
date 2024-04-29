#!/bin/sh
set -eu

TEMP_REPO_DIR="wiki_action_$GITHUB_REPOSITORY$GITHUB_SHA"
TEMP_WIKI_DIR="temp_wiki_$GITHUB_SHA"

if [ -z "$WIKI_DIR" ]; then
    echo "Wiki location is not specified, using default wiki/"
    WIKI_DIR='wiki'
fi

if [ -z "$GITHUB_TOKEN" ]; then
    echo "Token is not specified"
    exit 1
fi


#Clone repo
echo "Cloning repo https://github.com/$GITHUB_REPOSITORY"
git clone "https://$GITHUB_ACTOR:$GITHUB_TOKEN@github.com/$GITHUB_REPOSITORY" "$TEMP_REPO_DIR"

#Clone wiki repo
echo "Cloning wiki repo https://github.com/$GITHUB_REPOSITORY.wiki.git"
cd "$TEMP_REPO_DIR"
git clone "https://$GITHUB_ACTOR:$GITHUB_TOKEN@github.com/$GITHUB_REPOSITORY.wiki.git" "$TEMP_WIKI_DIR"

ls
echo "HELLO WORLD THIS IS MY FILE" > $WIKI_DIR/helloworld.md

#Get commit details
author=`git log -1 --format="%an"`
email=`git log -1 --format="%ae"`
message=`git log -1 --format="%s"`

echo "Copying edited wiki"
cp -R "$TEMP_WIKI_DIR/.git" "$WIKI_DIR/"

echo "Checking if wiki has changes"
cd "$WIKI_DIR"
git config --local user.email "$email"
git config --local user.name "$author" 
git add .
if git diff-index --quiet HEAD; then
  echo "Nothing changed"
  exit 0
fi

echo "Pushing changes to wiki"
git commit -m "$message" && git push "https://$GITHUB_ACTOR:$GITHUB_TOKEN@github.com/$GITHUB_REPOSITORY.wiki.git"