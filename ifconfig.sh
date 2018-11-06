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