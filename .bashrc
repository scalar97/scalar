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

# set encvironemental variables.
export CLICOLOR=1
export CDPATH=".:~:~/Desktop/:~/Desktop/GIT/"
export LSCOLORS=ExFxBxDxCxegedabagacad
export EDITOR="emacs-25.3"
export PATH="$PATH:~/.local/bin/:."
# export PS1='[\[\033[1;35m\]\u\[\033[01;32m\]@\h\[\033[m\] \[\033[1;33m\]\W\[\033[1;30m\] $(date '+%I:%M')\[\033[0;m\]]\$ '
export PS1='\[\033[1;31m\]\W \[\033[0;m\]\$ '
export PS2="$ "

# set global variable based on OS in (LINUX, DARWIN)

if test $(uname) = 'Linux'; then
    # if .alias is being used on Arch-Linux
    OPEN="xdg-open"
    # enable color support on Arch-Linux
    if [ -x /usr/bin/dircolors ]; then
      test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" \
	                   || eval "$(dircolors -b)"
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
    # create aliaces and write them to file for later sourcing
    echo 'alias '$1="'$2'" >> ~/.alias
    . ~/.bashrc # symlink or file depending on OS
}
#google search and youtube search from comand line
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
#compile java main package later will look for spacific package
function jac() {
    ret=$([ $(basename $PWD) == "java" ] && echo 0 || echo 1)
    [ $ret == "0" ] || pushd . > /dev/null  && builtin cd ~/Desktop/GIT/Java-OOP/java
    rm -f ie/dit/*.class && javac ie/dit/*.java && java ie.dit.Main
    [ $ret == "0" ] || popd > /dev/null
}
# go up the directory tree to find a .git folder, return if / is reached.
function jump_run() {
    pushd . > /dev/null # save the current directory
    while [ ! -d ".git/" ]  && [ $(basename $PWD) != '/' ] ; do
	builtin cd ../
    done
    echo && pwd
    
    # run the comand passsed if a remote repository was found
    [ $(basename $PWD) != "/" ] && echo $1 && popd > /dev/null && return 0
    popd > /dev/null && echo "Error: no remote branch found." && return 1
}
# now uses the same funtion to perfom different git command rather having a custom for each
function git_do() {
    if [ -d ".git" ]; then
        case "$1" in
	    *"open"*) $OPEN $2$(basename $PWD) ;;
	    *"commit"*) $1 "$2" ;;
	esac
    else
	# if no repository was found. simply open github main page
        [[ "$1" = *"open"* ]] && jump_run '$1 $2$(basename $PWD)' >/dev/null || $1 $2
	[[ "$1" = *"commit"* ]] && echo  "$1 '$2'" | jump_run # will print error if no branch was found
    fi
}
# get the status of all the remote repositories in a given folder
function git_dir() {
    # check if current directory is already a branch or run through every subdirectory.
    [ -d ".git" ] && git $1 || {
	  for dir in */ ; do
	      [ -d "$dir/.git" ] && echo && builtin cd $dir &&  git $1
	      [ -d ".git" ] && builtin cd ../  # only cd .. if builtin cd $dir happened 
	  done
    }
}
# sources the aliaces
. ~/.alias
