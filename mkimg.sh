#!/bin/bash
ARCH=$1
IMG=rootfs-${ARCH}.img

if [ -f ${IMG} ];then
    rm ${IMG}
fi

echo "making image..."
dd if=/dev/zero of=${IMG} bs=1M count=1500
mkfs.ext4 ${IMG}
mkfs.ext4 rootfs_debian_${ARCH}.ext4

if [-d tmp ];then 
    rm -rf tmp
fi

mkdir ./tmp
echo "copy data into rootfs..."
mount -t ext4 ${IMG} tmp/ -o loop
cp -af rootfs_debian_${ARCH}/* tmpfs/


rsync -axHAX --progress rootfs-${ARCH}/* tmp/

umount tmp/
rm -rf tmp/

chmod 777 ${IMG}

#e2fsck -p -f ${IMG}
#resize2fs -M ${IMG}
