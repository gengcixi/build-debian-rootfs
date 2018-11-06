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

apt-get install -y locales locales-all procps
apt-get install -y language-pack-en-base sudo ssh
apt-get install -y net-tools network-manager ethtool wireless-tools ifupdown iputils-ping
apt-get install -y rsyslog libncurses5-dev libncursesw5-dev
apt-get install -y bash-completion python vim git  build-essential
apt-get install -y perl tree usbutils

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
mv etc/systemd/system/getty.target.wants/getty\@tty1.service etc/systemd/system/getty.target.wants/getty\@ttyS1.service
ln -sf  etc/systemd/system/getty.target.wants/getty\@ttyS1.service lib/systemd/system/serial-getty\@.service
ln -sf /sbin/init init

echo nameserver 114.114.114.114>/etc/resolv.conf
echo nameserver 8.8.8.8>>/etc/resolv.conf
update-rc.d ifconfig.sh defaults
