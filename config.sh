#!/bin/bash

echo "deb http://cdn.debian.net/debian stretch main contrib non-free">>etc/apt/source.list
echo "deb-src http://cdn.debian.net/debian stretch  main contrib non-free">>etc/apt/source.list
echo "deb https://mirrors.tuna.tsinghua.edu.cn/debian/ stretch main non-free contrib">>etc/apt/source.list
echo "deb https://mirrors.tuna.tsinghua.edu.cn/debian/ stretch-updates main non-free contrib">>etc/apt/source.list
echo "deb https://mirrors.tuna.tsinghua.edu.cn/debian/ stretch-backports main non-free contrib">>etc/apt/source.list
echo "deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ stretch main non-free contrib">>etc/apt/source.list
echo "deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ stretch-updates main non-free contrib">>etc/apt/source.list
echo "deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ stretch-backports main non-free contrib">>etc/apt/source.list
echo "deb https://mirrors.tuna.tsinghua.edu.cn/debian-security/ stretch/updates main non-free contrib">>etc/apt/source.list
echo "deb-src https://mirrors.tuna.tsinghua.edu.cn/debian-security/ stretch/updates main non-free contrib">>etc/apt/source.list

apt-get update
echo debian.unisoc>etc/hostname
echo "127.0.1.1	debian.unisoc">>etc/hosts
echo "Enter root password:"
passwd root
useradd -G sudo -m -s /bin/bash unisoc
echo "Enter unisoc password:"
passwd unisoc

function install_packages()
{
	# echo "=========start install packages========"
	apt-get install -y locales-all
	apt-get install -y procps
	apt-get install -y python-software-properties
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
	apt-get clean
	# echo "=========ended install packages========"
}

install_packages
rm /bin/sh
ln -sf /bin/bash /bin/sh

ln -sf /lib/systemd/system/multi-user.target  etc/systemd/system/default.target
rm etc/systemd/system/getty.target.wants/getty\@tty1.service
ln -sf /lib/systemd/system/serial-getty@.service /etc/systemd/system/getty.target.wants/getty@ttyS1.service
ln -sf /sbin/init init
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
sed -i 's/ExecStart=-\/sbin\/agetty/ExecStart=-\/sbin\/agetty --autologin root/g' /lib/systemd/system/serial-getty\@.service

echo nameserver 114.114.114.114>/etc/resolv.conf
echo nameserver 8.8.8.8>>/etc/resolv.conf
update-rc.d start-on-boot.sh defaults
