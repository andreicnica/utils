###################################################################
#
# utils.sh
# 
# 
# Shell Script containing useful functions to handle certain tasks
#
# 
# Author: Marcel Gotsch
# Date:   10.12.2014
#
###################################################################
#!/bin/zsh
#
# Colorize output
#
declare -A color_map
color_map["black"]="\033[0;30m"
color_map["black/b"]="\033[1;30m"
color_map["black/u"]="\033[4;30m"
color_map["red"]="\033[0;31m"
color_map["red/b"]="\033[1;31m"
color_map["red/u"]="\033[4;31m"
color_map["green"]="\033[0;32m"
color_map["green/b"]="\033[1;32m"
color_map["green/u"]="\033[4;32m"
color_map["yellow"]="\033[0;33m"
color_map["yellow/b"]="\033[1;33m"
color_map["yellow/u"]="\033[4;33m"
color_map["blue"]="\033[0;34m"
color_map["blue/b"]="\033[1;34m"
color_map["blue/u"]="\033[4;34m"
color_map["magenta"]="\033[0;35m"
color_map["magenta/b"]="\033[1;35m"
color_map["magenta/u"]="\033[4;35m"
color_map["cyan"]="\033[0;36m"
color_map["cyan/b"]="\033[1;36m"
color_map["cyan/u"]="\033[4;36m"
color_map["gray"]="\033[0;37m"
color_map["gray/b"]="\033[1;37m"
color_map["gray/u"]="\033[4;37m"
color_map["white"]="\033[0m"

colorize(){
    local output=''
    if [ -z "$1" ]; then
        echo ""
    elif [ -z "$2" ] || [[ ${color_map["$2"]} == "" ]]; then
        echo $1
    else
        echo "${color_map["$2"]}$1${color_map["white"]}"    
    fi
}


#
# Print Functions
#

print(){
    if [ -z "$2" ]; then
        echo -n $1 >&2
    else
        echo -n `colorize $1 $2` >&2
    fi
}

println(){
    if [ -z "$2" ]; then
        echo $1 >&2
    else
        echo `colorize $1 $2` >&2
    fi   
}

error(){
    if [ -z "$1" ]; then
        return 0
    elif [ -z "$2" ]; then
        print "`colorize "[Error]" red` $1"
    else
        print "`colorize "[Error] in $1" red` : $2"
    fi
}

warning(){
    if [ -z "$2" ]; then
        print "`colorize "[Warning]" yellow` $1"
    else
        print "`colorize "[Warning] in $1" yellow` : $2"
    fi 
}

#
# Prompt Functions
#

ask(){
    local question=$1
    while true; do
        local answer=''
        print "$question (Y/n) "
        read answer

        if [[ "$answer" == "Y" ]]; then
            return 0
        elif [[ "$answer" == "n" ]]; then
            return 1
        else println "What did you say?" yellow
        fi
    done
}

ask_for_input(){
    local question=$1
    local input=''
    while true; do
        print "$question: "
        read input

        if [[ "$input" == "" ]]; then
            println "Sorry, but that's unacceptable!" yellow
        else break
        fi
    done

    echo $input
}

ask_for_input_with_default(){
    local question=$1
    local default=$2
    local input=''

    print "$question [$default]: "
    read input

    if [[ "$input" == "" ]]; then
        input=$default
    fi

    echo $input
}

ask_for_executable(){
    local executable=''
    while true; do
        executable=`ask_for_input "$1"`

        if ! validate_executable $executable; then
            println "Oops. Couldn't find $executable" red/b
        else break
        fi
    done

    echo $executable
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
            println "Oops. Couldn't find $executable" red/b
        else break
        fi
    done

    echo $executable
}

ask_for_file(){
    local file=''
    while true; do
        file=`ask_for_input "$1"`

        if [ ! -f $file ]; then
            println "Oops. Couldn't find $file" red/b
        else break
        fi
    done

    echo $file
}

ask_for_directory(){
    local directory=''
    while true; do
        directory=`ask_for_input "$1"`

        if [ ! -d $directory ]; then
            println "Oops. Couldn't find $directory" red/b
        else break
        fi
    done

    echo $directory
}

#
# Path and Folder Functions
#

join_path(){
    echo "$1/$2"
}