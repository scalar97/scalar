#
# ~/.bash_profile
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend
# checks and resises the window size if necessary.
shopt -s checkwinsize

# custom prompt

get_ps1() {
    # nested working directory from home directory or outside and no ~ expansion
    [[ "$PWD" = "$HOME"* ]] && escape=5 || escape=3
    ps1="$(pwd | cut -d '/' -f-$escape)"
    [[ $(uname) = "Linux" ]] && echo -e "${ps1//$HOME/\~}" ||echo -e "${ps1//$HOME/~}"
}
# set shell  variables.
ICU4C="/usr/local/opt/icu4c"
GIT_WORKSPACE="$HOME/Desktop/GIT"

# openSSL
export PATH="/usr/local/opt/openssl/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/openssl/lib"
export CPPFLAGS="-I/usr/local/opt/openssl/include"
export PKG_CONFIG_PATH="/usr/local/opt/openssl/lib/pkgconfig"

# readline
export LDFLAGS="-L/usr/local/opt/readline/lib"
export CPPFLAGS="-I/usr/local/opt/readline/include"

# GOOGLE CLOUD SDK
# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/tati/Library/google-cloud-sdk/path.bash.inc' ]; then
  . '/Users/tati/Library/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/tati/Library/google-cloud-sdk/completion.bash.inc' ]; then
  . '/Users/tati/Library/google-cloud-sdk/completion.bash.inc';
fi

export CLICOLOR=1
export PATH=".:$PATH:~/.local/bin/:$ICU4C/bin:$ICU4C/sbin:$GIT_WORKSPACE/.dotfiles"
export PKG_CONFIG_PATH="/usr/local/opt/icu4c/lib/pkgconfig"
export CDPATH=".:~:~/Desktop/:~/Desktop/GIT/"
export LSCOLORS=ExFxBxDxCxegedabagacad
export EDITOR="emacs"
export PS1='\[\033[1;30m\]$(get_ps1)..\[\033[1;31m\]$(basename $PWD) \[\033[1;30;m\]\$\[\033[0;m\] '
export PS2="$ "

# set global variable based on OS in (LINUX, DARWIN)
if test $(uname) = 'Linux'; then
    # if .alias is being used on Arch-Linux
    OPEN="xdg-open"
    # enable color support on Arch-Linux
    if [ -x /usr/bin/dircolors ]; then
      test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    fi
    # eneble auto completion
    if [ -f /usr/share/bash-completion/bash_completion ]; then
      . /usr/share/bash-completion/bash_completion
    fi
else
    OPEN="open" # on Darwin use open
    # eneble auto completion
    if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
    fi
fi

# shell functions

# create an alias and add it to the alias config file
al(){
    if [ "$#" -eq 0 ]; then
        # simply edit dot alias
        $EDITOR ~/.alias
    else
	# create an alias then write it to ~/.alias
	echo 'alias '$1="'$2'" >> ~/.alias
    fi
    . ~/.bashrc
}
#google search and youtube and github code search from command line
google() {
    search=""; option=$1; query="https:/"
    while (( "$#" )); do
	shift
	search="$search%20$1"
    done
    if [ "$option" == '-github' ]; then
        query="$query/github.com/search?l=Java&type=Code&q";
    else
	query="$query/www."$([[ "$option" == '-youtube' ]] &&
	echo -n "youtube.com/results?search_query" || echo -n "google.com/search?q");
    fi
    $OPEN "$query=$(echo $search)"
}
# go up the directory tree to find a .git folder, return if / is reached.
function jump_run() {
    pushd . > /dev/null # save the current directory
    while [ ! -d ".git/" ]  && [ $(basename $PWD) != '/' ] ; do
	builtin cd ../
    done
    
    # run the comand passsed if a remote repository was found
    [ $(basename $PWD) != "/" ] && eval $@ && popd > /dev/null && return 0
    popd > /dev/null && echo "Error: no remote branch found." && return 1
}
# now uses the same funtion to perfom different git command rather having a custom for each
function git_do() {
    if [ -d ".git" ]; then
      case "$1" in
	    *"commit"*) $1 "$2" && git push;;
	    "githu"*) github ;;
      esac
    else
	# if no repository was found. simply open github main page
	[[ "$1" = *"commit"* ]] && jump_run "${1} '${2}' && git push" && return 0
	[[ "$1" = "githu"* ]] && eval jump_run github && return 0 || github && return 1

    fi
}
# pulls, get the status, or log  of all the remote repositories in a given folder at once
function git_dir() {
    # check if current directory is already a branch or run through every subdirectory.
    pushd . > /dev/null
    for dir in $(find $GIT_WORKSPACE -maxdepth 1); do
	[ -d "$dir/.git" ] && builtin cd $dir && printf "\n\033[1;33m$(basename $PWD)\033[0m\n" && eval "$@" && builtin cd ../
    done
    popd > /dev/null
}

# sources the aliaces
. ~/.alias
