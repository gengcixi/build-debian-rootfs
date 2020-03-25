#!/bin/bash

apt-get update

function install_packages()
{
	# echo "=========start install packages========"
	apt-get install -y locales-all
	apt-get install -y procps
	apt-get install -y software-properties-common
	apt-get install -y libncurses5-dev
	apt-get install -y libncursesw5-dev
	apt-get install -y python
	apt-get install -y vim
	apt-get install -y git
	apt-get install -y build-essential
	apt-get install -y perl
	apt-get install -y tree
	apt-get install -y lrzsz
	apt-get install -y lsof
	apt-get install -y strace
	apt-get install -y psmisc
	apt-get install -y makedumpfile
	apt-get install -y crash
	apt-get install -y libdw1
	apt-get install -y liblzo2-2
	apt-get install -y kexec-tools
	apt-get clean
	# echo "=========ended install packages========"
}

install_packages
