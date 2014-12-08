#!/bin/sh
set -e

#
# Functions
#
print(){
    echo $1 >&2
}

ask(){
    local question=$1
    while true; do
        local answer=''
        read -p "$question? (Y/n)" answer

        if [ "$answer" == "Y" ]; then
            return 0
        elif [ "$answer" == "n" ]; then
            return 1
        else print "What?!"
        fi
    done
}

ask_for_input(){
    local question=$1
    local input=''
    while true; do
        read -p "$question: " input

        if [[ "$input" == "" ]]; then
            print "Sorry, but that's unacceptable..."
        else break
        fi
    done

    echo $input
}

ask_for_input_with_default(){
    local question=$1
    local default=$2
    local input=''

    read -p "$question [$default]: " input

    if [[ "$input" == "" ]]; then
        print "Keeping the default..."
        input=$default
    fi

    echo $input
}

#
# Welcome
#
print "Welcome to the Git config tool."
print "I'll help you configuring your Git installation."

if ! ask "Are you ready"; then
    exit 0
fi

#
# Start asking questions
#
username=`ask_for_input "What's your name"`
email=`ask_for_input "What's your email"`
editor=`ask_for_input_with_default "Choose your favorite editor" vim`
difftool=`ask_for_input_with_default "Choose your difftool" opendiff`

# Info output
print ""
print "Your configuration"
print "------------------"
print "Username: $username"
print "E-Mail: $email"
print "Editor: $editor"
print "Difftool: $difftool"
print ""

while ! ask "Is that okay"; do
    username=`ask_for_input "What's your name"`
    email=`ask_for_input "What's your email"`
    editor=`ask_for_input_with_default "Choose your favorite editor" vim`
    difftool=`ask_for_input_with_default "Choose your difftool" opendiff`

    # Info output
    print ""
    print "Your configuration"
    print "------------------"
    print "Username: $username"
    print "E-Mail: $email"
    print "Editor: $editor"
    print "Difftool: $difftool"
    print ""
done

#
# End
#

# Validate chosen executables
if ! `which $editor > /dev/null 2> /dev/null`; then
    print "Sorry, but I couldn't find $editor"
    exit 1
fi

if ! `which $difftool > /dev/null 2> /dev/null`; then
    print "Sorry, but I couldn't find $difftool"
    exit 1
fi

#
# Additionals
#

if ask "Enable UI colors"; then
    print "Yay colors are on!"
    git config --global color.ui true
else
    print "Ok, no color it is!"
    git config --global color.ui false
fi

if ask "Enable 'simple' push"; then
    print "Simple push it is!"
    git config --global push.default simple
else
    print "Set the push method to 'matching'"
    git config --global push.default matching
fi

if ask "Do you wish to use aliases"; then

    if ask "Should I define some shorthands (e.g. co = checkout)"; then
        git config --global alias.co checkout
        git config --global alias.ci commit
        git config --global alias.st status
        git config --global alias.br branch

        print "Defined:"
        print "co = checkout"
        print "ci = commit"
        print "st = status"
        print "br = branch"
    fi

    if ask "Should I define useful log aliases"; then
        git config --global alias.graph 'log --pretty=format:"%h %s" --graph'
        git config --global alias.hist 'log --pretty=format:"%h - %an, %ar : %s"'

        print "Defined: graph, hist"
    fi
fi

if ask "Do you wish to use a commit template"; then
    git_tpl_file=$HOME/.gitmessage
    cat << EOT> $git_tpl_file
[branch]
EOT

    git config --global commit.template $git_tpl_file
fi

git config --global user.name "$username"
git config --global user.email "$email"
git config --global core.editor "`which $editor`"
git config --global merge.tool "`which $difftool`"

print "Git is now configured. Enjoy :)."
