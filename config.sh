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

#rm /bin/sh
#ln -sf /bin/bash /bin/sh

ln -sf /lib/systemd/system/multi-user.target  etc/systemd/system/default.target
rm etc/systemd/system/getty.target.wants/getty\@tty1.service
ln -sf /lib/systemd/system/serial-getty@.service /etc/systemd/system/getty.target.wants/getty@ttyS1.service
ln -sf /sbin/init init
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
sed -i 's/ExecStart=-\/sbin\/agetty/ExecStart=-\/sbin\/agetty --autologin root/g' /lib/systemd/system/serial-getty\@.service

echo nameserver 114.114.114.114>/etc/resolv.conf
echo nameserver 8.8.8.8>>/etc/resolv.conf
update-rc.d start-on-boot.sh defaults
echo "Config rootfs done"
