#!/bin/bash

disable_console_log()
{
        while true
        do
                dmesg -n 1
        done
}
run_test()
{
        chown root:root /opt/ltp -R
        cd /opt/ltp
        rm results/*
	for  line  in  `cat scenario_groups/default`
	do
		echo ${line}
		./runltp -p -l ${line}.log -f ${line} -S runtest/blacklist_sprd
		cat results/${line}.log
	done
}
disable_console_log &
run_test
