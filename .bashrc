#
# ~/.bash_profile
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000
# disable adding duplicated lines or starting with space
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend
# checks and resises the window size if necessary.
# shopt -s checkwinsize

# partial path creation

get_ps1() {
    # nested working directory from home directory or outside and no ~ expansion
    [[ "$PWD" = "$HOME"* ]] && escape=5 || escape=3
    ps1="$(pwd | cut -d '/' -f-$escape)"
    [[ $(uname) = "Linux" ]] && echo -e "${ps1//$HOME/\~}" ||echo -e "${ps1//$HOME/~}"
}
# set encvironemental variables.
# Node.js dependency variables
ICU4C="/usr/local/opt/icu4c"
# GIT workspace
GIT_WORKSPACE="$HOME/Desktop/GIT"
# openSSL
export PATH="/usr/local/opt/openssl/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/openssl/lib"
export CPPFLAGS="-I/usr/local/opt/openssl/include"
export PKG_CONFIG_PATH="/usr/local/opt/openssl/lib/pkgconfig"

# readline
export LDFLAGS="-L/usr/local/opt/readline/lib"
export CPPFLAGS="-I/usr/local/opt/readline/include"
 
export CLICOLOR=1
export ANDROID_HOME=/Users/$USER/Library/Android/sdk
export PATH=${PATH}:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
export PATH=".:$PATH:~/.local/bin/:$ICU4C/bin:$ICU4C/sbin:$GIT_WORKSPACE/UnixArena:/Applications/XAMPP/xamppfiles/bin"
export PKG_CONFIG_PATH="/usr/local/opt/icu4c/lib/pkgconfig"
export CDPATH=".:~:~/Desktop/:~/Desktop/GIT/"
export LSCOLORS=ExFxBxDxCxegedabagacad
export EDITOR="emacs-25.3"
export PS1='\[\033[1;30m\]$(get_ps1)..\[\033[1;31m\]$(basename $PWD) \[\033[1;30;m\]\$\[\033[0;m\] '
export PS2="$ "

# Custom variables
rc="$HOME/.bashrc" #save the .bashrc file path in a variable for fast typing

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
    OPEN="open" # on Darwin xdg-open equivalent is open
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
	. ~/.bashrc # .bashrc can be a symlink or file depending on OS
    fi
}
#google search and youtube search from command line
google()
{
    search=""
    for term in $@; do
	if [[ "$term" == "-youtube" ]]; then
	    continue
	else
	    search="$search%20$term"
	fi
    done
    $OPEN "https://www."$([[ "$1" == '-youtube' ]] &&
	echo -n "youtube.com/results?search_query" ||
	echo -n "google.com/search?q" ; echo "=$search");
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
    [ -d ".git" ] && { ([ $# -eq 1 ] && $1) || ($1 | $2) ;} || {
	  for dir in */ ; do
	      [ -d "$dir/.git" ] && cd $dir >/dev/null && printf "\n\033[1;33m$(basename $PWD)\033[0m\n" && (([ $# -eq 1 ] && $1) || ($1 | $2 ))
	      [ -d ".git" ] && builtin cd ../  # only cd .. if builtin cd $dir happened 
	  done
    }
}

# sources the aliaces
. ~/.alias
