#!/bin/bash
#

prog=`basename $0`

if [ $# -lt 2 ]; then
echo "Usage: $0 <warning> <critical>"
exit 2
fi

NbUSERS=0
#DATE_TODAY=`date +%F`

NbUSERS_WARNING=$1
NbUSERS_CRITICAL=$2

if (( $NbUSERS_CRITICAL < $NbUSERS_WARNING ))
then
        echo "warning value must be less than the critical value"
        exit 5
fi

for i in `who |cut -d " " -f1 | sort -u`;
do
NbUSERS=`expr $NbUSERS + 1`
done

#for j in `who |cut -d " " -f10 | sort -u`;

if [ $NbUSERS -ge $NbUSERS_CRITICAL ]
then

        echo "USERS CRITICAL - $NbUSERS users currently logged in |users=$NbUSERS;$NbUSERS_WARNING;$NbUSERS_CRITICAL;0"
        exit 2

elif [ $NbUSERS -ge $NbUSERS_WARNING ]
then

        echo "USERS WARNING - $NbUSERS users currently logged in |users=$NbUSERS;$NbUSERS_WARNING;$NbUSERS_CRITICAL;0"
        exit 1

elif [ $NbUSERS_WARNING -gt $NbUSERS ]
then
        echo "USERS OK - $NbUSERS users currently logged in |users=$NbUSERS;$NbUSERS_WARNING;$NbUSERS_CRITICAL;0"
        exit 0
else
        echo "Unknown number of users currently logged in"
        exit 3
fi

