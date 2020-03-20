#!/bin/sh

TIME_STAMP=`date "+%Y_%m_%d_%H_%M"`

ifunction usage() {
	echo "Usage: $0 [COMMANDS]"
	echo
	echo "COMMANDS:"
	echo "  help        Show this help message and usage"
	echo "  init        Init symbolic link file to ~/ "
	echo "  clean       Clean synbolic link files on ~/ "
	echo
	exit 1
}

function install_deps() {
	# bash-completion
	if [ "$(uname)" == 'Darwin' ]; then
		brew install bash-completion
	elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
		sudo apt install -y bash-completion
	else
		echo "Your platform ($(uname -a)) is not supported."
		exit 1
	fi
}

function init() {
	# --- make directories
	mkdir -p ~/.vim/
	pwd=$PWD

	# --- backup exsiting .bash_profile
	if [ -e ~/.bash_profile ]; then
		mv ~/.bash_profile ~/.bash_profile_${TIME_STAMP}
	fi
	# --- backup exsiting .bashrc
	if [ -e ~/.bashrc ]; then
		mv ~/.bashrc ~/.bashrc_${TIME_STAMP}
	fi

	echo "[Init] Making symlinks"
	echo "- .vimrc to ${pwd}"
	ln -sf ~/dotfiles/vim/vimrc  ~/.vimrc
	echo "- .bash_profile to ${pwd}"
	ln -sf ~/dotfiles/bash/bash_profile  ~/.bash_profile
}


function main() {
	case "$1" in
		"init")
			install_deps
			init
			;;
		"clean")
			clean
			;;
		*)
			echo "$0: unexpected command \"$1\" "
			usage
			;;
	esac
}


if [ $# == 0 ]; then
	usage
	exit 1
else
	main $1
	exit 0
fi
