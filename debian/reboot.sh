STATE_OK=0

STATE_WARNING=1

FILE=/var/run/reboot-require

if [ -e $FILE ]

then 
                echo Reboot necessaire
                exit $STATE_WARNING
else
                echo Pas de reboot necessaire
                exit $STATE_OK
fi
