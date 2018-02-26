#
# ~/.bash_profile
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1='[\e[1;35m\u\e[01;32m@\h\e[00m \e[1;33m\]\W\e[1;30m $(date '+%I:%M')\e[00m]\$ '
PS2="$ "

if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
    source /etc/profile.d/vte.sh
fi

# set encvironemental variables.
export CLICOLOR=1
export CDPATH=".:~:~/Desktop/:~/Desktop/GIT/"
export LSCOLORS=ExFxBxDxCxegedabagacad

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# disable adding duplicated lines or starting with space
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# checks and resises the window size if necessary.
shopt -s checkwinsize

# set emacs as defaiult editor
export EDITOR="emacs-25.3"

# eneble auto completion
if [ -f $(brew --prefix)/etc/bash_completion ]; then
. $(brew --prefix)/etc/bash_completion
fi

# shell functions

# these swap functions are used with aliaces
swap() { $1 $3; $2;}
swap_pipe() { $1 $3| $2;}
cag() { cat "$1" | grep "$2"; } # cat and grep a keyword

cd() { [ $# -eq 0 ] && builtin cd ~  ||  { builtin cd "$1" && ls -FG;} }

# create an alias and add it to the alias config file
al(){
    # create aliaces and write them to file for later sourcing
    echo 'alias '$1="'$2'" >> ~/.alias
    . ~/.bash_profile
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
    open "https://www."$([[ "$1" == '-youtube' ]] &&
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
function jump_run() {
    dir=".git"
    pushd . > /dev/null # save the current directory

    # go up the directory tree until a branch is found,or the root is reached
    while [ ! -e $dir ]  && [ $(basename $PWD) != '/' ] ; do
	builtin cd ../
    done
    # run the comand passsed if a remote repository was found
    [ $(basename $PWD) != "/" ] && $1 && popd > /dev/null && return 0
    popd > /dev/null && echo "Error: no remote branch found."
}
# open github remote repository from current branch or from subdirectory
function github() {
        jump="open https://github.com/tati-z/"
        # search for the .git folder
        if [ -d ".git" ]; then
            $jump$(basename $PWD)
	else
            jump_run '$jump$(basename $PWD)'
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
# commits from current branch, or from any subdirectory of current branch
function gitc(){
    if [ -d ".git" ]; then
        git commit -m "$@" # commit to this branch
    else
	jump_run 'git commit -m "$@"'
    fi
}

# sources the aliaces
. ~/.alias

