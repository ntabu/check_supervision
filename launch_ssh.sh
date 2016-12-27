#!/bin/bash

way="/usr/local/libexec/check_ssh"
host_ip=`ifconfig eth0 | grep 'inet adr:' | cut -d: -f2 | awk '{ print $1}'`
echo $host_ip
echo $way
command=`$way -4 -p 22 $host_ip`
echo $command

status=`echo ${command:3:4}`
echo $status

#test=`echo ("grep "OK" $status")`
#$test=`$status | awk '{ print $1}'`

if [ $status = "OK" ]
then
        echo "No reboot"
        exit 0
else
        echo "Reboot"
        /etc/init.d/ssh restart
        exit $?
fi
