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
        else print "Invalid answer!"
        fi
    done
}

ask_for_input(){
    local question=$1
    local input=''
    while true; do
        read -p "$question " input

        if [[ "$input" == "" ]]; then
            print "Sorry, but that's unacceptable..."
            continue
        else break
        fi
    done

    echo $input
}

ask_for_input_with_default(){
    local question=$1
    local default=$2
    local input=''
    while true; do
        read -p "$question " input

        if [[ "$input" == "" ]]; then
            print "Using default... $default"
            input=$default
            break
        else
            break
        fi
    done

    echo $input
}

#
# Start asking questions
#

username=`ask_for_input "What's your name?"`
email=`ask_for_input "What's your email?"`
editor=`ask_for_input_with_default "Choose your favorite editor [vim]." vim`
difftool=`ask_for_input_with_default "Choose your difftool [opendiff]." opendiff`

#
# End
#

# Info output
print "Your configuration"
print "------------------"
print "Username: $username"
print "E-Mail: $email"
print "Editor: $editor"
print "Difftool: $difftool"

# Validate chosen executables
if ! `which $editor > /dev/null 2> /dev/null`; then
    print "$editor not found"
    exit 1
fi

if ! `which $difftool > /dev/null 2> /dev/null`; then
    print "$eddifftoolitor not found"
    exit 1
fi

#
# Additionals
#

if ask "Color UI"; then
    print "Coloring: Enabled"
    git config --global color.ui true
else
    print "Coloring: Disabled"
    git config --global color.ui false
fi

if ask "Enable Push Method Simple"; then
    print "Simple Push: Enabled"
    git config --global push.default simple
else
    print "Simple Push: Disabled"
    git config --global push.default matching
fi

if ask "Create useful aliases"; then

    if ask "Use command shorteners (e.g. co = checkout)"; then
        git config --global alias.co checkout
        git config --global alias.ci commit
        git config --global alias.st status
        git config --global alias.br branch

        print "Configured:"
        print "co = checkout"
        print "ci = commit"
        print "st = status"
        print "br = branch"
    fi

    if ask "Simplified log output"; then
        git config --global alias.graph 'log --pretty=format:"%h %s" --graph'
        git config --global alias.hist 'log --pretty=format:"%h - %an, %ar : %s"'

        print "Configured: graph, hist"
    fi
fi

if ask "Create a custom template directory"; then
    tpldir=$HOME/.git_template

    if [ -d "$tpldir" ]; then
        print "Alreay exists $tpldir"
    else
        mkdir $tpldir
        git config --global init.templatedir "$tpldir"

        git_tpl_file=$tpldir/gitmessage.txt

        if ask "Create a commit template"; then

            cat << EOT> $git_tpl_file
[<%branch%>]
EOT

            git config --global commit.template $git_tpl_file
        fi

        if ask "Init prepare commit message hook"; then
            hooks_folder=$tpldir/hooks
            mkdir $hooks_folder
            hook_file=$hooks_folder/prepare-commit-msg

            cat << EOT> $hook_file
COMMIT_EDITMSG=\$1
branch_name=`git branch | awk '{print $2}'`
sed -i 's/<%branch%>/\$branch_name/g' \$COMMIT_EDITMSG
EOT
        fi
    fi
fi

git config --global user.name "$username"
git config --global user.email "$email"
git config --global core.editor "`which $editor`"
git config --global merge.tool "`which $difftool`"

print "DONE."
