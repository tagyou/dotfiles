#!/bin/sh

TIME_STAMP=`date "+%Y_%m_%d_%H_%M"`

function usage() {
	echo "Usage: $0 [COMMANDS]"
	echo
	echo "COMMANDS:"
	echo "  help        Show this help message and usage"
	echo "  init        Install deps & Init symlinks to ~/ "
	echo "  clean       Clean symlinks on ~/ "
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
		echo "Skip install bash-completion!"
		echo "Your platform ($(uname -a)) is not supported."
		exit 1
	fi
}

function setup_vscode() {
	if [ "$(uname)" == 'Darwin' ]; then
		VSCODE_SETTING_DIR="~/Library/Application\ Support/Code/User"
	else
		echo "Skip setup VSCode!"
		exit 1
	fi

	echo "[Init] Making symlinks"
	echo "- .vimrc to ${pwd}"
	rm "$VSCODE_SETTING_DIR/settings.json"
	ln -sf ~/dotfiles/vscode/settings.json "${VSCODE_SETTING_DIR}/settings.json"

	# install extention
	cat ~/dotfiles/vscode/extensions | while read line
	do
		code --install-extension $line
	done
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

function clean() {
	echo "- Remove .vimrc"
	rm -rf ~/.vimrc
	echo "- Remove .bash_profile"
	rm -rf ~/.bash_profile
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
