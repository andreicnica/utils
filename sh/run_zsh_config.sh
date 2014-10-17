#!/bin/sh
set -e

PROGNAME=$0

usage(){
  echo "usage: $PROGNAME [zsh]"
}

ask(){
  ANSWER=""

  while [ "$ANSWER" != "n" ] && [ "$ANSWER" != "Y" ]
  do
    read -p "$1 (Y/n)" ANSWER
  done

  echo "$ANSWER"
}

ZSH_EXECUTABLE=""
ZSHRC=$HOME/.zshrc

add_line(){
  echo $1 >> $ZSHRC
}

add_section(){
  add_line "\n# $1"
}

add_option(){
  add_line "setopt $1"
}

add_export(){
  add_line "export $1"
}

if [ -z "$1" ]; then
  ZSH_EXECUTABLE=/bin/bash
else
  ZSH_EXECUTABLE=$1
fi

echo "Using zsh @ $ZSH_EXECUTABLE"

if [ ! -s $ZSH_EXECUTABLE ]; then
  echo "No such file: $ZSH_EXECUTABLE"
  usage 
  exit -1
fi

# Check for the existence of a .zshrc file
if [ -s $ZSHRC ]; then
  echo "A .zshrc already exists in your home directory!" 

  ANSWER=$(ask "Do you wish to overwrite it?")
  
  if [ "$ANSWER" == "n" ]; then
    echo "Keeping the old .zshrc file"
    source $ZSHRC
    exit 0
  else
    rm -f $ZSHRC
  fi
fi

# Create a new .zshrc file
echo "# Configuration file for you zsh\n" > $ZSHRC

# Auto cd ?
ANSWER=$(ask "Enable auto cd?")
if [ "$ANSWER" == "Y" ]; then
  add_section "Enabling auto cd"
  add_option "auto_cd"
fi

# Colors ?
ANSWER=$(ask "Enable coloring?")
if [ "$ANSWER" == "Y" ]; then
  add_section "Enabling colors"
  add_line "autoload -U colors && colors"

  ANSWER=$(ask "Use custom color theme?")
  if [ "$ANSWER" == "Y" ]; then
    add_export "LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx"
  fi
fi

# Add /usr/local/bin to PATH ?
ANSWER=$(ask "Add /usr/local/bin to PATH?")
if [ "$ANSWER" == "Y" ]; then
  add_section "Adding /usr/local/bin to PATH"
  add_export "PATH=/usr/local/bin:\$PATH"
fi

# Add git completion ?
ANSWER=$(ask "Enable git tools?")
GIT_PROMPT_ENABLED=false

if [ "$ANSWER" == "Y" ]; then
  ZSH_VERSION_MAJOR=$(/bin/zsh --version|awk {'print $2'}|sed -E 's/\.[0-9]+\.[0-9]+//')

  if [ $ZSH_VERSION_MAJOR -lt 4 ]; then
    echo "Your zsh version does not support git completion by default!"
    echo "Please take a look at the web for the git-completion.zsh script."
  else
    add_section "Enabling git autocomplete"
    add_line "autoload -U compinit && compinit"
  fi

  ANSWER=$(ask "Enable git prompt?")
  if [ "$ANSWER" == "Y" ]; then
    GIT_PROMPT_SRC=https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh
    GIT_PROMPT_FILE=$HOME/.git-prompt.sh
    if [ ! -s $GIT_PROMPT_FILE ]; then
      curl $GIT_PROMPT_SRC -o $GIT_PROMPT_FILE
    fi

    add_line "source $GIT_PROMPT_FILE"
    add_option "prompt_subst"

    GIT_PROMPT_ENABLED=true
  fi
fi

# Overwrite ps1 with custom version
ANSWER=$(ask "Custom PS1 ?")
if [ "$ANSWER" == "Y" ]; then
  add_section "Using custom prompt"

  if [ $GIT_PROMPT_ENABLED ]; then
    add_export "PS1='%n(%l) %F{red}:%F{white} %d%F{red}\$(__git_ps1)\n%F{red}> %F{white}'"
  else
    add_export "PS1='%n(%l) %F{red}:%F{white} %d\n%F{red}> %F{white}'"
  fi
fi

# Add npm bin directory to current path?
ANSWER=$(ask "Export npm's current binary dir to PATH?")
if [ "$ANSWER" == "Y" ]; then
  add_section "Export npm's current binary dir to PATH"
  add_export "PATH=\$(npm bin):\$PATH"
fi



# Change the user's default shell to zsh
chsh -s $ZSH_EXECUTABLE

source $ZSHRC

echo "DONE."
