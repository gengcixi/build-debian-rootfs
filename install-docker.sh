#!/bin/bash
apt-get remove docker docker-engine docker.io
apt-get install apt-transport-https ca-certificates curl lsb-release software-properties-common

curl -fsSL https://mirrors.aliyun.com/docker-ce/linux/debian/gpg |apt-key add -

add-apt-repository "deb [arch=arm64] https://mirrors.aliyun.com/docker-ce/linux/debian stretch stable"
add-apt-repository "deb [arch=armhf] https://mirrors.aliyun.com/docker-ce/linux/debian stretch stable"
apt-get install docker-ce

