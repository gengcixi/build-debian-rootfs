# build-debian-rootfs

##build steps:

    1. ./build-debian-rootfs.sh arm|arm64
    2. ./ch-mount.sh -m ROOTFS
    3. in rootfs: run config.sh 
    4. finished config, exit
    5. ./ch-mount.sh -u ROOTFS
    6. DONE
