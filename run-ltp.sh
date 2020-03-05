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
        rm results/* -rf
	for  line  in  `cat scenario_groups/default`
	do
		echo ${line}
        ./runltp -p -l ${line}.result -f ${line} -S runtest/blacklist_sprd |tee ./results/${line}-test.log
		cat results/${line}.result
	done
}
disable_console_log &
run_test
