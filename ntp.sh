#!/bin/sh
#
COMMAND=$(ntpq -pn | grep -F '*' | awk '{print $1}' | cut -d "*" -f 2)
OFFSET=$(ntpq -pn | grep -F '*' | awk '{print $9}')
OFFSET_MS=$(ntpq -pn | grep -F '*' | awk '{print $9}' | cut -d "." -f 1 | cut -d "-" -f 2)

if [ -z "$COMMAND" ]
then
        echo "No synchronization with the time server"
        exit 2

else
        if [ $OFFSET_MS -gt 300 ]
        then
                echo CRITICAL $OFFSET_MS
                exit 2
        fi

        if [ $OFFSET_MS -gt 100 ]
        then
                echo WARNING $OFFSET_MS
                exit 1
        fi

        echo "Synchronized with the server: "$COMMAND" offset: "$OFFSET
        echo $OFFSET_MS ms
        exit 0
fi
