#!/bin/zsh
set -e

# Include utils
if [ ! -f ./utils.zsh ]; then
    echo "\033[1;31mCould not find the utils script!\033[0m"
    exit 2
fi
source ./utils.zsh

say(){
    println "... $1" cyan
}


#
# Welcome
#
println ""
println "Welcome to the Git config tool"
println "------------------------------" cyan
println ""
println "I'll help you configuring your Git installation."
println ""


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

while [[ "$username" == "" ]] || ! ask "Is that okay"; do
    username=`ask_for_input "Whats your name"`
    email=`ask_for_input "What's your email"`
    editor=`ask_for_executable_with_default "Choose your favorite editor" vim`
    difftool=`ask_for_executable_with_default "Choose your difftool" opendiff`

    # Info output
    println ""
    println "Your configuration"
    println "------------------" cyan
    println "Username: $username"
    println "E-Mail: $email"
    println "Editor: $editor"
    println "Difftool: $difftool"
    println ""
done

say "All right then, here comes the fancy stuff :)"

#
# Additionals
#

if ask "Enable UI colors"; then
    say "Yay colors everywhere :)"
    git config --global color.ui true
else
    say "Ok, as you wish. No fancy colors :("
    git config --global color.ui false
fi

if ask "Enable 'simple' push"; then
    say "Simple push it is."
    git config --global push.default simple
else
    say "Push is now set to 'matching'"
    git config --global push.default matching
fi

if ask "Do you wish to use aliases"; then

    if ask "How about some nice shorthands (e.g. co = checkout)"; then
        git config --global alias.co checkout
        git config --global alias.ci commit
        git config --global alias.st status
        git config --global alias.br branch

        say "Defined:"
        say "co = checkout"
        say "ci = commit"
        say "st = status"
        say "br = branch"
    fi

    if ask "Should I define useful log aliases"; then
        git config --global alias.graph 'log --pretty=format:"%h %s" --graph'
        git config --global alias.hist 'log --pretty=format:"%h - %an, %ar : %s"'

        say "Defined: graph, hist"
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

say "Git is now configured. Enjoy :)."
