#!/bin/sh

sleep 10

while :
do
stillRunning=$(ps -ef |grep "UpdateApp" |grep -v "grep")
if [ "$stillRunning" ] ; then
kill -9 `pidof UpdateApp`
else
UpdateApp
echo "UpdateApp service was exited!"
fi
sleep 10
done

