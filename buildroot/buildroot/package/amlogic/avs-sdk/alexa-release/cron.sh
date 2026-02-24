#!/bin/sh

startCount=0
while :
do
let startCount++
echo $startCount > ./run_count.txt
echo "Current DIR is " $PWD
stillRunning=$(ps -ef |grep "${HOME_PATH}/run.sh" |grep -v "grep")
if [ "$stillRunning" ] ; then
echo "TWS service was already started by another way"
echo "Kill it and then startup by this shell, other wise this shell will loop out this message annoyingly"
kill -9 `pidof SampleApp`
else
echo "TWS service was not started"
echo "Starting service ..."
${HOME_PATH}/run.sh
echo "TWS service was exited!"
fi
sleep 10
done

