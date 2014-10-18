#!/bin/sh
set -e

# CONSTANTS
PROGNAME=$0
ZSH_CUSTOM_PATH=$1
ZSHRC_CUSTOM_PATH=$2

# Default paths
ZSH_EXECUTABLE=/bin/zsh
ZSHRC=$HOME/.zshrc


# Functions

usage(){
    echo "usage: $PROGNAME [zsh] [zshrc]"
}

ask(){
    QUESTION=$1
    while true; do
        read -p "$QUESTION? (Y/n)" ANSWER

        if [ "$ANSWER" == "Y" ]; then
            return 0
        elif [ "$ANSWER" == "n" ]; then
            return 1
        fi
    done
}

# Adds the given input as new line to the zshrc
add_line(){
    echo $1 >> $ZSHRC
}

# Adds a new section by inserting a comment from the given input
add_section(){
    add_line "\n# $1"
}

# Adds a new option to the zshrc
add_option(){
    add_line "setopt $1"
}

# Adds a new export to the zshrc
add_export(){
    add_line "export $1"
}

if [ ! -z "$ZSH_CUSTOM_PATH" ]; then
    ZSH_EXECUTABLE=$ZSH_CUSTOM_PATH
fi

if [ ! -z "$ZSHRC_CUSTOM_PATH" ]; then
    ZSHRC=$ZSHRC_CUSTOM_PATH
fi

echo "Using zsh @ $ZSH_EXECUTABLE"
echo "Placing zshrc @ $ZSHRC"

if ! ask "Continue"; then
    echo "Aborted."
    exit 0
fi

if [ ! -s $ZSH_EXECUTABLE ]; then
    echo "No such file: $ZSH_EXECUTABLE"
    usage 
    exit -1
fi

# Check for the existence of a .zshrc file
if [ -s $ZSHRC ]; then
    echo "A .zshrc already exists"

    if ask "Do you wish to keep it"; then
        echo "Keeping the old .zshrc file"
        source $ZSHRC
        exit 0
    else
        rm -f $ZSHRC
    fi
fi

# Create a new .zshrc file
echo "# Configuration file for you zsh" > $ZSHRC

# Auto cd ?
if ask "Enable auto cd"; then
    add_section "Enabling auto cd"
    add_option "auto_cd"
fi

# Colors ?
if ask "Enable colors"; then
    add_section "Enabling colors"
    add_line "autoload -U colors && colors"

    if ask "Use custom color theme"; then
        add_export "LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx"
    fi
fi

# Add /usr/local/bin to PATH ?
if ask "Add /usr/local/bin to the PATH"; then
    add_section "Adding /usr/local/bin to PATH"
    add_export "PATH=/usr/local/bin:\$PATH"
fi

# Add git completion ?
GIT_PROMPT_ENABLED=false

if ask "Enable git tools"; then
    ZSH_VERSION_MAJOR=$(/bin/zsh --version|awk {'print $2'}|sed -E 's/\.[0-9]+\.[0-9]+//')

    if [ $ZSH_VERSION_MAJOR -lt 4 ]; then
        echo "Your zsh version does not support git completion by default!"
        echo "Please take a look at the web for the git-completion.zsh script."
    else
        add_section "Enabling git autocomplete"
        add_line "autoload -U compinit && compinit"
    fi

    if ask "Enable git prompt"; then
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
if ask "Use custom prompt style"; then
    add_section "Using custom prompt"

    if [ $GIT_PROMPT_ENABLED ]; then
        add_export "PS1='%n(%l) %F{red}:%F{white} %d%F{red}\$(__git_ps1)\n%F{red}> %F{white}'"
    else
        add_export "PS1='%n(%l) %F{red}:%F{white} %d\n%F{red}> %F{white}'"
    fi
fi

# Add npm bin directory to current path?
if ask "Export npm's binary dir to the PATH"; then
    add_section "Export npm's current binary dir to PATH"
    add_export "PATH=\$(npm bin):\$PATH"
fi


# Change the user's default shell to zsh
if ask "Change to zsh now"; then
    chsh -s $ZSH_EXECUTABLE
    source $ZSHRC
fi

echo "DONE."
