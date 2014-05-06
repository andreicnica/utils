#!/bin/sh

set -e

VIM_CONFIG=$HOME/.vimrc

if [ -f $VIM_CONFIG ]; then
  ANSWER=""

  while [ "$ANSWER" != "n" ] && [ "$ANSWER" != "Y" ]
  do
    echo "$HOME already contains a .vimrc."
    echo "Overwrite the existing file? (Y/n)"
    read ANSWER
  done

  if [ "$ANSWER" == "n" ]; then
    exit 0
  fi
fi

echo "filetype plugin indent on" > $VIM_CONFIG
echo "syntax on" >> $VIM_CONFIG
echo ":set expandtab" >> $VIM_CONFIG
echo ":set tabstop=2" >> $VIM_CONFIG
echo ":retab" >> $VIM_CONFIG
echo ":set shiftwidth=2" >> $VIM_CONFIG

echo "DONE."


