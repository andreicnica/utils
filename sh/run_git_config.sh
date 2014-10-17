#!/bin/sh

usage() {
  echo "usage: $0 AUTHOR EMAIL"		
}

set -e

AUTHOR=$1
EMAIL=$2

if [ -z "$AUTHOR" ] || [ -z "$EMAIL" ]; then
  usage
  exit -1
fi

echo "Using: "
echo $AUTHOR
echo $EMAIL

ANSWER=""

while [ "$ANSWER" != "n" ] && [ "$ANSWER" != "Y" ]
do
  echo "Proceed? (Y/n)"
  read ANSWER
done

if [ "$ANSWER" == "n" ]; then
  exit 0
fi

git config --global user.name "$AUTHOR"
git config --global user.email $EMAIL
git config --global core.editor vim
git config --global merge.tool opendiff
git config --global color.ui true
git config --global push.default simple

GIT_COMMIT_TEMPLATE=$HOME/.gitmessage.txt
echo "[branch]::[ticket: X]\n" > $GIT_COMMIT_TEMPLATE
echo "what happenend" >> $GIT_COMMIT_TEMPLATE

git config --global commit.template $GIT_COMMIT_TEMPLATE

echo "DONE."
