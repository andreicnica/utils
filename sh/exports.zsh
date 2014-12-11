#
# Exports for zsh
#

# Enable color in grep
export GREP_OPTIONS='--color=auto'
export GREP_COLOR='3;33'

# Export locale
export LC_ALL=C

# ls options
export CLICOLOR=1
export LSCOLORS=xxbxbxhxBxHxHxbxgxgxgx=
export LS_OPTIONS='--color=auto'
#eval $(dircolors ~/.dircolors.ansi-dark)
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Adding /usr/local/bin to PATH
export PATH=/usr/local/bin:$PATH

# Export npm's current binary dir to PATH
export PATH=$(npm bin):$PATH

# Using a custom prompt style
export PS1='%n(%l) %F{red}:%F{white} %d%F{red}$(__git_ps1)
%F{red}> %F{white}'

# Short hand variable and function for the dev folder
export devf=$HOME/dev
