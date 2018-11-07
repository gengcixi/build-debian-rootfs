#!/bin/bash
ARCH=$1
IMG=rootfs-${ARCH}.img

if [ -f ${IMG} ];then
    rm ${IMG}
fi

dd if=/dev/zero of=${IMG} bs=1M count=2500
mkfs.ext4 ${IMG}

if [-d tmp ];then 
    rm -rf tmp
fi

mkdir ./tmp
mount ${IMG} tmp/

rsync -axHAX --progress rootfs-${ARCH}/* tmp/

umount tmp/
rm -rf tmp/

e2fsck -p -f ${IMG}
resize2fs -M ${IMG}
