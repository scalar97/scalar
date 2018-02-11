#
# ~/.bash_profile
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1="[\[\033[1;35m\]\u\[\033[01;32m\]@\h\[\033[00m\] \[\033[1;33m\]\W\[\033[00m\]]\$ "
PS2="$ "

if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
        source /etc/profile.d/vte.sh
fi

#export PYTHONSTARTUP="$HOME/.pyrc"
export CDPATH=".:~:~/Desktop/:~/Desktop/GIT/"

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# disable adding duplicated lines or starting with space
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend


# checks and resises the window size if necessary.
shopt -s checkwinsize

# enable color support
export CLICOLOR=1

# set emacs as defaiult editor
export EDITOR="emacs-25.3"

# eneble auto completion
if [ -f $(brew --prefix)/etc/bash_completion ]; then
. $(brew --prefix)/etc/bash_completion
fi

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

# sources the aliaces
. ~/.alias
