#!/bin/bash
USER=`whoami`
if [ $USER != root ];then 
    SUPER=sudo 
else
    SUPER=" "
fi
echo "$USER    adm   $SUPER"

ARCH=$1
ROOTFS=rootfs-${ARCH}

$SUPER apt-get install binfmt-support qemu qemu-user-static debootstrap  multistrap binfmt-support  dpkg-cross

#
#wget http://ftp.debian.org/debian/pool/main/d/debian-archive-keyring/debian-archive-keyring_2012.4_all.deb
#sudo dpkg -i debian-archive-keyring_2014.4_all.deb

$SUPER apt-get install debian-archive-keyring
# $SUPER apt-key add /usr/share/keyrings/debian-archive-keyring.gpg

if [ -d ${ROOTFS} ];then
    $SUPER rm -rf ${ROOTFS}
fi
$SUPER mkdir ${ROOTFS}

if [ ${ARCH} = arm64 ];then
    $SUPER debootstrap \
        --arch=${ARCH} \
        --include="locales,sudo,ssh,net-tools,network-manager,openssl,ethtool,wireless-tools,ifupdown,iputils-ping,rsyslog,bash-completion,apt-transport-https,ca-certificates,curl,htop,usbutils" \
        --foreign stretch ${ROOTFS} http://mirrors.163.com/debian/

    $SUPER  cp /usr/bin/qemu-aarch64-static ${ROOTFS}/usr/bin
elif [ ${ARCH} = arm ];then
    $SUPER debootstrap \
        --arch=${ARCH}hf \
        --include="locales,sudo,ssh,net-tools,network-manager,openssl,ethtool,wireless-tools,ifupdown,iputils-ping,rsyslog,bash-completion,apt-transport-https,ca-certificates,curl,htop,usbutils" \
        --foreign stretch ${ROOTFS} hhttp://mirrors.163.com/debian/
    $SUPER  cp /usr/bin/qemu-arm-static ${ROOTFS}/usr/bin
fi
#$SUPER debootstrap --arch=${ARCH} --foreign stretch ${ROOTFS} http:/ftp.debian.org/debian/
#$SUPER debootstrap --arch=${ARCH} --foreign stretch ${ROOTFS} http://deb.debian.org/debian/

$SUPER  cp /etc/hosts ${ROOTFS}/etc/hosts
$SUPER  cp /proc/mounts ${ROOTFS}/etc/mtb
$SUPER chmod 666 ${ROOTFS}/etc/fstab
$SUPER echo "proc /proc proc defaults 0 0" >> ${ROOTFS}/etc/fstab
$SUPER echo "sysfs /sys sysfs defaults 0 0" >> ${ROOTFS}/etc/fstab
$SUPER chmod 644 ${ROOTFS}/etc/fstab
$SUPER mkdir -p ${ROOTFS}/usr/share/man/man1/
$SUPER mknod ${ROOTFS}/dev/console c 5 1

DEBIAN_FRONTEND=noninteractive
DEBCONF_NONINTERACTIVE_SEEN=true
LC_ALL=C
LANGUAGE=C
LANG=C
$SUPER chroot ${ROOTFS} debootstrap/debootstrap --second-stage

$SUPER cp config.sh ${ROOTFS}/
$SUPER cp install-package.sh ${ROOTFS}/
$SUPER cp run-ltp.sh ${ROOTFS}/root/
$SUPER cp start-on-boot.sh ${ROOTFS}/etc/init.d/
