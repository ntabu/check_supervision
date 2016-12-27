#!/bin/sh

LEVEL_WARNING=$1
LEVEL_CRITICAL=$2

STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3
STATE_DEPENDENT=4

current_connections=`cat /proc/net/ip_conntrack | wc -l`

max_connections=`cat /proc/sys/net/ipv4/netfilter/ip_conntrack_max`
pourcent_util=`echo $(($current_connections*100/$max_connections))`

message="utilisation du nombre de connexion Ã  $pourcent_util%"

echo $message

if [ "$pourcent_util" -ge $LEVEL_CRITICAL ]
then
         exit $STATE_CRITICAL
fi

if [ "$pourcent_util" -ge $LEVEL_WARNING ]
then
        exit $STATE_WARNING
else
        exit $STATE_OK
fi
