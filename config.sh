#!/bin/bash

echo "deb http://cdn.debian.net/debian stretch main contrib non-free">>etc/apt/source.list
echo "deb-src http://cdn.debian.net/debian stretch  main contrib non-free">>etc/apt/source.list

apt-get update
echo debian.unisoc>etc/hostname
echo "Enter root password:"
passwd root
useradd -G sudo -m -s /bin/bash unisoc
echo "Enter unisoc password:"
passwd unisoc

apt-get install -y locales
apt-get install -y locales-all
apt-get install -y procps
apt-get install -y sudo
apt-get install -y ssh
apt-get install -y net-tools
apt-get install -y network-manager
apt-get install python-software-properties
apt-get install software-properties-common
apt-get install -y openssl
apt-get install -y ethtool
apt-get install -y wireless-tools
apt-get install -y ifupdown
apt-get install -y iputils-ping
apt-get install -y rsyslog
apt-get install -y libncurses5-dev
apt-get install -y libncursesw5-dev
apt-get install -y bash-completion
apt-get install -y python
apt-get install -y vim
apt-get install -y git
apt-get install -y build-essential
apt-get install -y perl
apt-get install -y tree
apt-get install -y usbutils

echo "=========start build htop========"
wget http://hisham.hm/htop/releases/2.2.0/htop-2.2.0.tar.gz
tar xvf htop-2.2.0.tar.gz
cd htop-2.2.0
./configure
make 
make install 

cd ..
rm htop* -rf
rm /bin/sh
ln -sf /bin/bash /bin/sh

echo "=========ended build htop========"

#rm usr/bin/qemu-aarch64-static

ln -sf /lib/systemd/system/multi-user.target  etc/systemd/system/default.target
#mv etc/systemd/system/getty.target.wants/getty\@tty1.service etc/systemd/system/getty.target.wants/getty\@ttyS1.service
rm etc/systemd/system/getty.target.wants/getty\@tty1.service
#ln -sf  etc/systemd/system/getty.target.wants/getty\@ttyS1.service lib/systemd/system/serial-getty\@.service
ln -sf /lib/systemd/system/serial-getty@.service /etc/systemd/system/getty.target.wants/getty@ttyS1.service
ln -sf /sbin/init init

echo nameserver 114.114.114.114>/etc/resolv.conf
echo nameserver 8.8.8.8>>/etc/resolv.conf
update-rc.d ifconfig.sh defaults
