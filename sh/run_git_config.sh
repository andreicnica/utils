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
        else print "What did you say?"
        fi
    done
}

ask_for_input(){
    local question=$1
    local input=''
    while true; do
        read -p "$question: " input

        if [[ "$input" == "" ]]; then
            print "Sorry, but that's unacceptable!"
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
        print "Leaving the default..."
        input=$default
    fi

    echo $input
}

validate_executable(){
    if `which $1 > /dev/null 2> /dev/null`; then
        return 0
    else return 1
    fi
}

ask_for_executable_with_default(){
    local executable=''
    while true; do
        executable=`ask_for_input_with_default "$1" $2`

        if ! validate_executable $executable; then
            print "Oops. Couldn't find $executable"
        else break
        fi
    done

    echo $executable
}

#
# Welcome
#
print "Welcome to the Git config tool."
print "I'll help you configuring your Git installation."

if ! ask "Ready to start"; then
    exit 0
fi

#
# Start asking questions
#
username=''
email=''
editor=''
difftool=''

while [ "$username" == "" ] || ! ask "Is that okay"; do
    username=`ask_for_input "What's your name"`
    email=`ask_for_input "What's your email"`
    editor=`ask_for_executable_with_default "Choose your favorite editor" vim`
    difftool=`ask_for_executable_with_default "Choose your difftool" opendiff`

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

print "All right then, here comes the fancy stuff :)"

#
# Additionals
#

if ask "Enable UI colors"; then
    print "Yay colors everywhere :)"
    git config --global color.ui true
else
    print "Ok, as you wish. No fancy colors :("
    git config --global color.ui false
fi

if ask "Enable 'simple' push"; then
    print "Simple push it is."
    git config --global push.default simple
else
    print "Push is now set to 'matching'"
    git config --global push.default matching
fi

if ask "Do you wish to use aliases"; then

    if ask "How about some nice shorthands (e.g. co = checkout)"; then
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
