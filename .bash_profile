#
# ~/.bash_profile
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1='[\[\033[1;35m\]\u\[\033[01;32m\]@\h\[\033[00m\] \[\033[1;33m\]\W\e[1;30m $(date '+%I:%M')\[\033[00m\]]\$ '
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

swap() { $1 $3; $2;}
swap_pipe() { $1 $3| $2;}
cd() { [ $# -eq 0 ] && builtin cd ~  ||  { builtin cd "$1" && ls -FG;} }

# create an alias and add it to the alias config file
al()
{
	#alias arg1 into arg2 then write this alias to file_name
	#also sources the ~/.bash_profile file to include the changes
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
    if [[ "$1" == '-youtube' ]]; then
        open https://www.youtube.com/results?search_query=$search
    else
	open "http://www.google.com/search?q=$search"
    fi
}
#compile java main package later will look for spacific package
function jac() {
    ret=$([ $(basename $PWD) == "java" ] && echo 0 || echo 1)
    [ $ret == "0" ] || pushd . && builtin cd ~/Desktop/GIT/Java-OOP/java
    rm -f ie/dit/*.class && javac ie/dit/*.java && java ie.dit.Main
    [ $ret == "0" ] || popd
}
function jumpb() {
    # save current directory to the stack to come back to it later
    dir=".git"
    pushd . > /dev/null # save the current directory

    # go up the directory tree until a branch is found, return if the root is reached
    while [ ! -e $dir ]  && [ $(basename $PWD) != '/' ] ; do
    builtin cd ../
    done
    # run the comand passsed if a remote repository was found
    [ $(basename $PWD) != "/" ] && $1 && popd > /dev/null && return 0
    popd > /dev/null && echo "Error: no master branch"
}
# open github remote repository from current repo or from subdirectory
function github() {
        jump="xdg-open https://github.com/tati-z/"
        # search for the git folder
        if [ -d ".git" ]; then
            $jump$(basename $PWD)
	else
            jump_run '$jump$(basename $PWD)'
	fi    
}
function gitc(){
    if [ -d ".git" ]; then
        git commit -m "$dir" # commit to this branch
    else
	jump_run 'git commit -m "$1"'
    fi
}

# sources the aliaces
. ~/.alias
