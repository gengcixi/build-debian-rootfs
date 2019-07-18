#! /bin/sh
### BEGIN INIT INFO
# Provides: OnceDoc
# Required-Start: $network $remote_fs $local_fs
# Required-Stop: $network $remote_fs $local_fs
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
# Short-Description: start and stop node
# Description: OnceDoc
### END INIT INFO
WEB_DIR='/var/www/oncedoc'
WEB_APP='svr/service.js'
#location of node you want to use
NODE_EXE=/usr/local/bin/node
start()
{
	echo "Starting usb0"
	/sbin/ifconfig usb0 192.168.8.8 netmask 255.255.255.0
	/sbin/route add default gw 192.168.8.1 usb0
	# mount wcn module data
	mkdir -p /dev/block/platform/soc/soc:ap-ahb/20600000.sdio/by-name/
	cd /dev/block/platform/soc/soc\:ap-ahb/20600000.sdio/by-name/
	wcnmodemPartNo=`fdisk -l |grep "wcnmodem"| awk '{print $1}'`
	gpsglPartNo=`fdisk -l |grep "gpsgl"| awk '{print $1}'`
	gpsbdPartNo=`fdisk -l |grep "gpsbd"| awk '{print $1}'`
	ln -sf /dev/mmcblk0p${wcnmodemPartNo} wcnmodem
	ln -sf /dev/mmcblk0p${gpsglPartNo} gpsgl
	ln -sf /dev/mmcblk0p${gpsbdPartNo} gpsbd

	#config usb adbd functions
        mount -t configfs none /sys/kernel/config
        sn=`awk '{for(i=1;i<=NF;i++) if($i~/serialno/) print $i}' /proc/cmdline`
        udc=`ls /sys/class/udc/`
        sn=${sn#*=}

        mkdir /sys/kernel/config/usb_gadget/g1
        echo "0x1782" > /sys/kernel/config/usb_gadget/g1/idVendor
        echo "0x4002" > /sys/kernel/config/usb_gadget/g1/idProduct

        mkdir /sys/kernel/config/usb_gadget/g1/strings/0x409
        echo $sn > /sys/kernel/config/usb_gadget/g1/strings/0x409/serialnumber
        echo "Spreadtrum" > /sys/kernel/config/usb_gadget/g1/strings/0x409/manufacturer
        echo "Spreadtrum Phone" > /sys/kernel/config/usb_gadget/g1/strings/0x409/product

        mkdir -p /sys/kernel/config/usb_gadget/g1/functions/ffs.adb
        mkdir -p /dev/usb-ffs/adb
        /bin/mount -t functionfs  adb  /dev/usb-ffs/adb

        mkdir -p /sys/kernel/config/usb_gadget/g1/configs/b.1
        mkdir -p /sys/kernel/config/usb_gadget/g1/configs/b.1/strings/0x409
        echo "Conf 1" > /sys/kernel/config/usb_gadget/g1/configs/b.1/strings/0x409/configuration
        echo "120" > /sys/kernel/config/usb_gadget/g1/configs/b.1/MaxPower

        ln -s /sys/kernel/config/usb_gadget/g1/functions/ffs.adb /sys/kernel/config/usb_gadget/g1/configs/b.1/f1
        echo "adb" > /sys/kernel/config/usb_gadget/g1/configs/b.1/strings/0x409/configuration

        echo "Starting adbd..."
        /usr/bin/adbd &

        sleep 1
        echo "$udc" > /sys/kernel/config/usb_gadget/g1/UDC
}
stop()
{
	echo "This program cann't be stopped"
}
case "$1" in
	start)
		start
		;;
	stop)
		stop
		;;
	restart)
		stop
		#start
		;;
	*)
		echo "Usage: /etc/init.d/ifconfig {start|stop|restart}"
		;;
esac
exit 0
