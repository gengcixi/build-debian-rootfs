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

$SUPER mkdir ${ROOTFS}
if [ ${ARCH} = arm64 ];then
    $SUPER debootstrap --arch=${ARCH} --foreign stretch ${ROOTFS} http://cdn.debian.net/debian/
    $SUPER  cp /usr/bin/qemu-aarch64-static ${ROOTFS}/usr/bin
elif [ ${ARCH} = arm ];then
    $SUPER debootstrap --arch=${ARCH}hf --foreign stretch ${ROOTFS} http://cdn.debian.net/debian/
    $SUPER  cp /usr/bin/qemu-arm-static ${ROOTFS}/usr/bin
fi
#$SUPER debootstrap --arch=${ARCH} --foreign stretch ${ROOTFS} http:/ftp.debian.org/debian/

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
$SUPER cp ifconfig.sh ${ROOTFS}/etc/init.d/
